import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/widgets/confirmation_dialog.dart';
import 'package:madistock/widgets/text_input_field.dart';

class CategoryListBottomSheet extends StatefulWidget {
  const CategoryListBottomSheet({super.key});

  @override
  _CategoryListBottomSheetState createState() => _CategoryListBottomSheetState();
}

class _CategoryListBottomSheetState extends State<CategoryListBottomSheet> {
  List<Map<String, dynamic>> _categories = [];
  bool _loading = true;
  final _nameController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);
    final categories = await DatabaseHelper().getCategories();
    setState(() {
      _categories = categories;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ccaColor,
        title: Text(
          'Liste des catégories',
          style: TextStyle(
            fontSize: 18.dp,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: whiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        backgroundColor: ccaColor,
        child: const Icon(Icons.add, color: whiteColor),
      ),
      body: Stack(
        children: [
          /// ✅ Background Image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SvgPicture.asset (
              'assets/undraw_groceries_4via.svg',
            ),
          ),

          /// ✅ Voile semi-transparent
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withOpacity(0.2),
          ),

          /// ✅ Contenu principal
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 20.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: ccaColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.1.h),
                  _loading
                      ? const Center(
                        child: CircularProgressIndicator(color: ccaColor),
                      )
                      : _categories.isEmpty
                      ? Center(
                        child: Text(
                          'Aucune catégorie disponible',
                          style: TextStyle(
                            fontSize: 18.dp,
                            color: blackColor,
                          ),
                        ),
                      )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return ListTile(
                        title: Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 18.dp,
                            color: blackColor,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.mode_edit_rounded,
                                color: ccaColor,
                              ),
                              onPressed: () async => await _showEditCategoryDialog(context, category),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                                color: redColor,
                              ),
                              onPressed: () async {
                                final bool confirm = await _showConfirmationDialog(
                                  context,
                                  title: 'Confirmer la suppression',
                                  message: 'Êtes-vous sûr de vouloir supprimer cette catégorie ?',
                                );
                                if (confirm) await _deleteCategory(category['id']);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _resetForm() {
    _nameController.clear();
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter une catégorie"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Veuillez renseigner le nom de la catégorie",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                InputField(
                  onTap: () {},
                  onChange: (String value) {  },
                  focus: true,
                  prefixIcon: Icons.category_rounded,
                  hint: "Nom de la catégorie",
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom de la catégorie';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            // Bouton Annuler
            ElevatedButton(
              onPressed: () {
                _resetForm();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: whiteColor,
                backgroundColor: redColor,
              ),
              child: const Text('Annuler'),
            ),

            // Bouton Ajouter
            ElevatedButton(
              onPressed: () async {
                EasyLoading.show(status: 'Loading...');

                if (_formKey.currentState!.validate()) {
                  final newCategory = {'name': _nameController.text};

                  await _dbHelper.insertCategory(newCategory);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catégorie ajoutée avec succès'),
                      backgroundColor: greenColor,
                    ),
                  );

                  _resetForm();
                  Navigator.pop(context);
                  await _loadCategories(); // Recharger la liste des catégories
                }
                EasyLoading.showSuccess('Saved Successfully');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: whiteColor,
                backgroundColor: ccaColor,
              ),
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  // --- Fonctions de suppression, modification et confirmation ---

  Future<void> _deleteCategory(int categoryId) async {
    setState(() => _loading = true);
    try {
      await DatabaseHelper().deleteCategory(categoryId);
      await _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catégorie supprimée avec succès !'),
          backgroundColor: greenColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de la suppression de la catégorie.'),
          backgroundColor: redColor,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _showEditCategoryDialog(BuildContext context, Map<String, dynamic> category) async {
    final TextEditingController nameController = TextEditingController(text: category['name']);
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la catégorie'),
        content: TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nom de la catégorie',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text(
              'Enregistrer',
              style: TextStyle(color: greenColor),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _updateCategory(category['id'], nameController.text);
    }
  }

  Future<void> _updateCategory(int categoryId, String newName) async {
    setState(() => _loading = true);
    try {
      await DatabaseHelper().updateCategory({
        'id': categoryId,
        'name': newName,
      });
      await _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catégorie modifiée avec succès !'),
          backgroundColor: greenColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de la modification de la catégorie.'),
          backgroundColor: redColor,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context, {required String title, required String message}) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: 'Confirmer',
        cancelText: 'Annuler',
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
    return confirmed ?? false;
  }
}
