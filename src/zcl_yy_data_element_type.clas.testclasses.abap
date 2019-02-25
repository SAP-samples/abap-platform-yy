*"* use this source file for your ABAP unit test classes
CLASS ltcl_yy_data_element_type DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS: the_element_type FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_yy_data_element_type IMPLEMENTATION.

  METHOD the_element_type.
    DATA(the_type) = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element_type=>structure ).
    cl_abap_unit_assert=>assert_equals( exp = zif_yy_data_element_type=>structure act = the_type->get_type_name( ) ).
  ENDMETHOD.

ENDCLASS.
