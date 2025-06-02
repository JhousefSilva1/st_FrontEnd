import 'package:flutter/material.dart';
import 'package:smarttolls/style/app_style.dart';

class PersonTypeFilter extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const PersonTypeFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildFilterButton(context, 'Todos', ''),
        _buildFilterButton(context, 'Administrador', 'admin'),
        _buildFilterButton(context, 'Cliente', 'cliente'),
        _buildFilterButton(context, 'Operador', 'operador'),
        if (selected.isNotEmpty)
          IconButton(
            tooltip: 'Limpiar filtro',
            icon: const Icon(Icons.clear, color: AppStyle.red),
            onPressed: () => onChanged(''),
          ),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, String value) {
    final isSelected = selected == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppStyle.primary.withOpacity(0.2),
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? AppStyle.primary : Colors.grey.shade600,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) => onChanged(value),
    );
  }
}
