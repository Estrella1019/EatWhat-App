import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/global_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// 结果页面 - 显示生成的食谱列表
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final S = AppLocalizations.of(context);

    if (S == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.recommendedRecipes),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // 可以添加重新生成的逻辑
            },
          ),
        ],
      ),
      body: globalProvider.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(S.generatingRecipe),
                ],
              ),
            )
          : globalProvider.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(globalProvider.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          globalProvider.clearError();
                          Navigator.pop(context);
                        },
                        child: Text(S.goBack),
                      ),
                    ],
                  ),
                )
              : globalProvider.recipes.isEmpty
                  ? Center(
                      child: Text(S.noRecipes),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: globalProvider.recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = globalProvider.recipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipe: recipe,
                                ),
                              ),
                            );
                          },
                          onReplace: () {
                            globalProvider.replaceRecipe(index);
                          },
                        );
                      },
                    ),
    );
  }
}
