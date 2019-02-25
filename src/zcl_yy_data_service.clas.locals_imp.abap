*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_data_element_unsupported IMPLEMENTATION.

  METHOD zif_yy_data_element~get_descriptor.
    r_descriptor = my_descriptor.
  ENDMETHOD.

  METHOD zif_yy_data_element~get_value.
    e_value = zif_yy_data_element=>co_unsupported_element.
  ENDMETHOD.

  METHOD constructor.
    my_descriptor = zcl_yy_data_descriptor=>create_instance( i_name = zif_yy_data_descriptor=>co_unnamed_object
                                                             i_type = NEW lcl_element_type_unsupported( ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_element_type_unsupported IMPLEMENTATION.

  METHOD zif_yy_data_element_type~get_type_name.
    r_type_name = zif_yy_data_element_type=>unsupported.
  ENDMETHOD.

ENDCLASS.
