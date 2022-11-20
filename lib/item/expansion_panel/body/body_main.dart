import 'package:flutter/material.dart';
import 'package:indexer_client/common/exceptions/exception_resolver.dart';
import 'package:indexer_client/common/item_warning_resolver.dart';
import 'package:indexer_client/item/barcode_service.dart';
import 'package:indexer_client/item/item_service.dart';

import '../../../api/api_spec.swagger.dart';
import '../../add/add_item_popup.dart';

part "body_table.dart";

part "bottom_buttons.dart";

part 'item_warning_text.dart';

part "quantity_selector.dart";

class ItemExpansionPanelBody extends StatelessWidget {
  final ItemDTO item;

  const ItemExpansionPanelBody({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            _ItemWarningText(item: item),
            _ItemTable(item: item),
            _QuantitySelector(
                onIncrement: (qty) => _onQuantityChange(context, qty),
                onDecrement: (qty) => _onQuantityChange(context, qty),
                value: item.quantity),
            _BottomButtons(
              onDelete: () => _onDelete(context),
              onEdit: () => _onEdit(context),
            )
          ],
        ));
  }

  void _onDelete(BuildContext context) {
    ItemService.getInstance(context).itemDeleteListener(item);
  }

  _onEdit(BuildContext context) {
    Future<ItemDTO?> editedItem = showDialog<ItemDTO>(
        context: context,
        builder: (ctx) => ModifyItemPopup(
              itemService: ItemService.getInstance(context),
              barcodeService: BarcodeService.getInstance(context),
              exceptionResolver: ExceptionResolver.getInstance(context),
              addNew: false,
              item: item,
            ));
    ItemService.getInstance(context).onItemEditedListener(editedItem, item);
  }

  _onQuantityChange(BuildContext context, int quantity) {
    ItemDTO newItem = $ItemDTOExtension(item).copyWith(quantity: quantity);
    ItemService.getInstance(context).saveAndUpdateList(newItem, item);
  }
}