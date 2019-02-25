*"* use this source file for your ABAP unit test classes
CLASS ltcl_data_element_integer DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    DATA: data_reader  TYPE REF TO if_sxml_reader,
          data_element TYPE REF TO zif_yy_data_element.
    CONSTANTS: expected_value TYPE i VALUE 42.
    METHODS:
      setup RAISING cx_static_check,
      validate_number FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_data_element_integer IMPLEMENTATION.

  METHOD setup.
    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE yy = expected_value RESULT XML json_writer.
    DATA(json_code) = cl_abap_conv_codepage=>create_in( )->convert( source = json_writer->get_output( ) ).
    data_reader = cl_sxml_string_reader=>create( input = json_writer->get_output( ) ).
    data_reader->read_next_node( ).
  ENDMETHOD.

  METHOD validate_number.

    DATA: my_value TYPE i.

    data_element = zcl_yy_data_element_number=>create_instance( ).
    cl_abap_unit_assert=>assert_bound( data_element ).
    CAST zif_yy_data_element_builder( data_element )->build( i_data_reader = data_reader
                                                             i_element_name = 'GUGLHUPF' ).

    data_element->get_value( IMPORTING e_value = my_value ).
    cl_abap_unit_assert=>assert_equals( act = my_value exp = expected_value ).

    DATA(my_descriptor) = data_element->get_descriptor( ).
    cl_abap_unit_assert=>assert_equals( act = my_descriptor->get_name( ) exp = 'GUGLHUPF' ).
    cl_abap_unit_assert=>assert_equals( act = my_descriptor->get_type( )->get_type_name( ) exp = zif_yy_data_element_type=>number ).

    CAST zif_yy_data_element_builder( data_element )->build( i_data_reader = data_reader
                                                             i_element_name = 'GUGLHUPF' ).
    data_element->get_value( IMPORTING e_value = my_value ).
    cl_abap_unit_assert=>assert_initial( my_value ).
    cl_abap_unit_assert=>assert_not_bound( data_element->get_descriptor( ) ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_data_element_float DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    DATA: data_reader  TYPE REF TO if_sxml_reader,
          data_element TYPE REF TO zif_yy_data_element.
    CONSTANTS: expected_value TYPE f VALUE '42.42'.
    METHODS:
      setup RAISING cx_static_check,
      validate_number FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_data_element_float IMPLEMENTATION.

  METHOD setup.
    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE yy = expected_value RESULT XML json_writer.
    DATA(json_code) = cl_abap_conv_codepage=>create_in( )->convert( source = json_writer->get_output( ) ).
    data_reader = cl_sxml_string_reader=>create( input = json_writer->get_output( ) ).
    data_reader->read_next_node( ).
  ENDMETHOD.

  METHOD validate_number.

    DATA: my_value TYPE f.

    data_element = zcl_yy_data_element_number=>create_instance( ).
    cl_abap_unit_assert=>assert_bound( data_element ).
    CAST zif_yy_data_element_builder( data_element )->build( i_data_reader = data_reader
                                                             i_element_name = 'APFELKUCHEN' ).

    data_element->get_value( IMPORTING e_value = my_value ).
    cl_abap_unit_assert=>assert_equals( act = my_value exp = expected_value ).

    DATA(my_descriptor) = data_element->get_descriptor( ).
    cl_abap_unit_assert=>assert_equals( act = my_descriptor->get_name( ) exp = 'APFELKUCHEN' ).
    cl_abap_unit_assert=>assert_equals( act = my_descriptor->get_type( )->get_type_name( ) exp = zif_yy_data_element_type=>number ).

  ENDMETHOD.

ENDCLASS.
