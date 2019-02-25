INTERFACE zif_yy_data_element PUBLIC.

  TYPES: BEGIN OF ty_structure_element,
           index   TYPE i,
           element TYPE REF TO zif_yy_data_element,
         END OF ty_structure_element,
         ty_structure TYPE SORTED TABLE OF zif_yy_data_element=>ty_structure_element WITH UNIQUE KEY index,
         BEGIN OF ty_table_element,
           index   TYPE i,
           element TYPE REF TO zif_yy_data_element,
         END OF ty_table_element,
         ty_table TYPE SORTED TABLE OF ty_table_element WITH UNIQUE KEY index.

  CONSTANTS: co_unsupported_element TYPE string VALUE 'I am unsupported, so sad!'.

  DATA: type TYPE zif_yy_data_element_type=>ty_type READ-ONLY.

  METHODS:
    get_value EXPORTING e_value TYPE any,
    get_descriptor RETURNING VALUE(r_descriptor) TYPE REF TO zif_yy_data_descriptor.

ENDINTERFACE.
