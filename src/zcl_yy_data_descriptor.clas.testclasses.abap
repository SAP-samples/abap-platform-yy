*"* use this source file for your ABAP unit test classes
CLASS ltcl_yy_data_descriptor DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS: the_descriptor FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_yy_data_descriptor IMPLEMENTATION.

  METHOD the_descriptor.
    DATA(the_type) = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element_type=>string ).
    DATA(the_descriptor) = zcl_yy_data_descriptor=>create_instance( i_name = 'ONKEL_HUGO' i_type = the_type ).
    cl_abap_unit_assert=>assert_equals( exp = 'ONKEL_HUGO' act = the_descriptor->zif_yy_data_descriptor~get_name( ) ).
    cl_abap_unit_assert=>assert_equals( exp = zif_yy_data_element_type=>string act = the_descriptor->zif_yy_data_descriptor~get_type( )->get_type_name( ) ).
  ENDMETHOD.

ENDCLASS.
