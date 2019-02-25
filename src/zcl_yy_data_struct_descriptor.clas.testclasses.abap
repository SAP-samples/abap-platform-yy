*"* use this source file for your ABAP unit test classes
CLASS ltcl_yy_structure_descriptor DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS: the_descriptor FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_yy_structure_descriptor IMPLEMENTATION.

  METHOD the_descriptor.
    DATA: structure_descriptor TYPE zif_yy_data_descriptor=>ty_structure_descriptor,
          element_descriptor   TYPE zif_yy_data_descriptor=>ty_struct_element_descriptor.

    element_descriptor-index = 1.
    element_descriptor-element = zcl_yy_data_descriptor=>create_instance( i_name = 'TRAGISCH' i_type = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element_type=>string ) ).
    INSERT element_descriptor INTO TABLE structure_descriptor.

    DATA(the_type) = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element_type=>structure ).
    DATA(the_descriptor) = zcl_yy_data_struct_descriptor=>create_instance( i_name = 'ONKEL_HUGO' i_type = the_type i_structure_descriptor = structure_descriptor ).
    cl_abap_unit_assert=>assert_equals( exp = 'ONKEL_HUGO' act = the_descriptor->zif_yy_data_descriptor~get_name( ) ).
    cl_abap_unit_assert=>assert_equals( exp = zif_yy_data_element_type=>structure act = the_descriptor->zif_yy_data_descriptor~get_type( )->get_type_name( ) ).
    cl_abap_unit_assert=>assert_equals( exp = structure_descriptor act = the_descriptor->zif_yy_data_struct_descriptor~get_structure( ) ).

  ENDMETHOD.

ENDCLASS.
