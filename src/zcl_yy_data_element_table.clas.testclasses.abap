*"* use this source file for your ABAP unit test classes
CLASS ltcl_data_element_table DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_s_guglhupf,
             number TYPE i,
             text   TYPE string,
           END OF ty_s_guglhupf,
           ty_t_guglhupf TYPE STANDARD TABLE OF ty_s_guglhupf.
    DATA: data_reader    TYPE REF TO if_sxml_reader,
          data_element   TYPE REF TO zif_yy_data_element,
          expected_table TYPE ty_t_guglhupf.
    METHODS:
      setup RAISING cx_static_check,
      validate_table FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_data_element_table IMPLEMENTATION.

  METHOD setup.
    DATA: expected_line TYPE ty_s_guglhupf.
    expected_line-number = 42.
    expected_line-text   = 'Gebäck'.
    INSERT expected_line INTO TABLE expected_table.
    expected_line-number = 23.
    expected_line-text   = 'Guzle'.
    INSERT expected_line INTO TABLE expected_table.
    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE yy = expected_table RESULT XML json_writer.
    DATA(json_code) = cl_abap_conv_codepage=>create_in( )->convert( source = json_writer->get_output( ) ).
    data_reader = cl_sxml_string_reader=>create( input = json_writer->get_output( ) ).
    data_reader->read_next_node( ).
    data_reader->read_next_node( ).
  ENDMETHOD.

  METHOD validate_table.

    DATA: my_value         TYPE zif_yy_data_element=>ty_table,
          table_element    type zif_yy_data_element=>ty_table.

    data_element = zcl_yy_data_element_table=>create_instance( ).
    cl_abap_unit_assert=>assert_bound( data_element ).
    CAST zif_yy_data_element_builder( data_element )->build( i_data_reader = data_reader
                                                             i_element_name = 'GUGLHUPF' ).

    data_element->get_value( IMPORTING e_value = my_value ).

    DATA(my_descriptor) = data_element->get_descriptor( ).
    " root-level tables don't get a name
    cl_abap_unit_assert=>assert_equals( act = my_descriptor->get_name( ) exp = zif_yy_data_descriptor=>co_unnamed_object ).
    cl_abap_unit_assert=>assert_equals( act = my_descriptor->get_type( )->get_type_name( ) exp = zif_yy_data_element_type=>table ).

    CAST zif_yy_data_element_builder( data_element )->build( i_data_reader = data_reader
                                                             i_element_name = 'GUGLHUPF' ).
    data_element->get_value( IMPORTING e_value = my_value ).
    cl_abap_unit_assert=>assert_initial( my_value ).
    cl_abap_unit_assert=>assert_not_bound( data_element->get_descriptor( ) ).

  ENDMETHOD.

ENDCLASS.
