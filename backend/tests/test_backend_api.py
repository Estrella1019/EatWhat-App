import importlib
import os
import sys
import tempfile
import unittest
from pathlib import Path

from fastapi.testclient import TestClient


BACKEND_ROOT = Path(__file__).resolve().parents[1]
if str(BACKEND_ROOT) not in sys.path:
    sys.path.insert(0, str(BACKEND_ROOT))


def clear_backend_modules() -> None:
    prefixes = ("api", "models", "schemas", "services")
    exact = {"config", "database", "main"}
    for name in list(sys.modules):
        if name in exact or name.startswith(prefixes):
            sys.modules.pop(name, None)


def build_test_client(db_path: str) -> TestClient:
    os.environ["DATABASE_URL"] = f"sqlite:///{db_path}"
    os.environ["JWT_SECRET"] = "test-secret"
    clear_backend_modules()
    app = importlib.import_module("main").app
    return TestClient(app)


class BackendApiTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.client = build_test_client(os.path.join(self.temp_dir.name, "test.db"))

    def tearDown(self) -> None:
        self.temp_dir.cleanup()

    def register_user(self, username: str = "chef") -> str:
        response = self.client.post(
            "/api/auth/register",
            json={
                "username": username,
                "email": f"{username}@example.com",
                "password": "Test123456",
            },
        )
        self.assertEqual(response.status_code, 200)
        return response.json()["data"]["access_token"]

    def test_auth_errors_use_http_status_codes(self) -> None:
        self.register_user("alice")

        duplicate = self.client.post(
            "/api/auth/register",
            json={
                "username": "alice",
                "email": "alice2@example.com",
                "password": "Test123456",
            },
        )
        self.assertEqual(duplicate.status_code, 409)
        self.assertEqual(duplicate.json()["code"], 409)

        login = self.client.post(
            "/api/auth/login",
            json={"username": "alice", "password": "wrong-password"},
        )
        self.assertEqual(login.status_code, 401)
        self.assertEqual(login.json()["message"], "用户名或密码错误")

    def test_generate_request_validation_rejects_invalid_payload(self) -> None:
        response = self.client.post(
            "/api/recipes/generate",
            json={"diners": 0, "ingredients": ["  "]},
        )
        self.assertEqual(response.status_code, 422)
        self.assertEqual(response.json()["code"], 422)
        self.assertIn("食材不能为空", response.json()["message"])

    def test_blank_user_inputs_are_rejected(self) -> None:
        token = self.register_user("bob")
        headers = {"Authorization": f"Bearer {token}"}

        allergen_response = self.client.post(
            "/api/users/allergens",
            json={"name": "   "},
            headers=headers,
        )
        self.assertEqual(allergen_response.status_code, 422)

        favorite_response = self.client.post(
            "/api/users/favorites",
            json={"recipe_name": "", "recipe_data": {"name": "番茄炒蛋"}},
            headers=headers,
        )
        self.assertEqual(favorite_response.status_code, 422)

    def test_duplicate_allergens_and_favorites_are_blocked(self) -> None:
        token = self.register_user("carol")
        headers = {"Authorization": f"Bearer {token}"}

        first_allergen = self.client.post(
            "/api/users/allergens",
            json={"name": "花生"},
            headers=headers,
        )
        self.assertEqual(first_allergen.status_code, 200)

        duplicate_allergen = self.client.post(
            "/api/users/allergens",
            json={"name": "花生"},
            headers=headers,
        )
        self.assertEqual(duplicate_allergen.status_code, 409)

        first_favorite = self.client.post(
            "/api/users/favorites",
            json={"recipe_name": "番茄炒蛋", "recipe_data": {"name": "番茄炒蛋"}},
            headers=headers,
        )
        self.assertEqual(first_favorite.status_code, 200)

        duplicate_favorite = self.client.post(
            "/api/users/favorites",
            json={"recipe_name": "番茄炒蛋", "recipe_data": {"name": "番茄炒蛋"}},
            headers=headers,
        )
        self.assertEqual(duplicate_favorite.status_code, 409)

    def test_ai_services_are_lazy_after_app_import(self) -> None:
        import services.llm_service as llm_service
        import services.yolo_service as yolo_service

        self.assertIsNone(llm_service._llm_service)
        self.assertIsNone(yolo_service._yolo_service)


if __name__ == "__main__":
    unittest.main()
