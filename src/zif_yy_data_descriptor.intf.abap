INTERFACE zif_yy_data_descriptor PUBLIC.

  TYPES: BEGIN OF ty_struct_element_descriptor,
           index   TYPE i,
           element TYPE REF TO zif_yy_data_descriptor,
         END OF ty_struct_element_descriptor,
         ty_structure_descriptor TYPE SORTED TABLE OF ty_struct_element_descriptor WITH UNIQUE KEY index.


  CONSTANTS: co_unnamed_object TYPE string VALUE 'YY'.

  METHODS:
    get_name RETURNING VALUE(r_name) TYPE string,
    get_type RETURNING VALUE(r_type) TYPE REF TO zif_yy_data_element_type.

ENDINTERFACE.
