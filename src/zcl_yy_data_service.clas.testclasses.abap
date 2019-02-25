*"* use this source file for your ABAP unit test classes
CLASS ltcl_data_element_string DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS:
      validate_string FOR TESTING RAISING cx_static_check,
      validate_number FOR TESTING RAISING cx_static_check,
      validate_structure FOR TESTING RAISING cx_static_check,
      validate_table FOR TESTING RAISING cx_static_check,
      validate_object FOR TESTING RAISING cx_static_check,
      crazy_json FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_data_element_string IMPLEMENTATION.

  METHOD validate_string.

    DATA: received_string TYPE string,
          expected_string TYPE string VALUE 'MONSTERKEKS'.

    DATA(data_service) = zcl_yy_data_service=>create_instance_with_data( i_data = expected_string ).
    cl_abap_unit_assert=>assert_bound( data_service ).
    DATA(data_element) = data_service->get_element( ).
    data_element->get_value( IMPORTING e_value = received_string ).
    cl_abap_unit_assert=>assert_equals( exp = expected_string act = received_string ).
    DATA(descriptor) = data_element->get_descriptor( ).
    cl_abap_unit_assert=>assert_equals( exp = zif_yy_data_element_type=>string act = descriptor->get_type( )->get_type_name( ) ).

  ENDMETHOD.

  METHOD validate_number.
    DATA: received_number TYPE i,
          expected_number TYPE i VALUE 42.

    DATA(data_service) = zcl_yy_data_service=>create_instance_with_data( i_data = expected_number ).
    cl_abap_unit_assert=>assert_bound( data_service ).
    DATA(data_element) = data_service->get_element( ).
    data_element->get_value( IMPORTING e_value = received_number ).
    cl_abap_unit_assert=>assert_equals( exp = expected_number act = received_number ).
    DATA(descriptor) = data_element->get_descriptor( ).
    cl_abap_unit_assert=>assert_equals( exp = zif_yy_data_element_type=>number act = descriptor->get_type( )->get_type_name( ) ).

  ENDMETHOD.

  METHOD validate_structure.
    TYPES: BEGIN OF ty_s_guglhupf,
             number TYPE i,
             text   TYPE string,
           END OF ty_s_guglhupf.

    DATA: expected_structure TYPE ty_s_guglhupf,
          received_structure TYPE zif_yy_data_element=>ty_structure,
          structure_element  TYPE zif_yy_data_element=>ty_structure_element,
          received_number    TYPE i,
          received_string    TYPE string.

    expected_structure-number = 42.
    expected_structure-text   = 'Guglhupf'.

    DATA(data_service) = zcl_yy_data_service=>create_instance_with_data( i_data = expected_structure ).
    cl_abap_unit_assert=>assert_bound( data_service ).
    DATA(data_element) = data_service->get_element( ).
    data_element->get_value( IMPORTING e_value = received_structure ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( received_structure ) ).
    READ TABLE received_structure INTO structure_element WITH TABLE KEY index = 1.
    structure_element-element->get_value( IMPORTING e_value = received_number ).
    cl_abap_unit_assert=>assert_equals( exp = expected_structure-number act = received_number ).
    READ TABLE received_structure INTO structure_element WITH TABLE KEY index = 2.
    structure_element-element->get_value( IMPORTING e_value = received_string ).
    cl_abap_unit_assert=>assert_equals( exp = expected_structure-text act = received_string ).

    DATA(descriptor) = data_element->get_descriptor( ).
    cl_abap_unit_assert=>assert_equals( exp = zif_yy_data_element_type=>structure act = descriptor->get_type( )->get_type_name( ) ).

  ENDMETHOD.

  METHOD validate_table.
    TYPES: BEGIN OF ty_s_guglhupf,
             number TYPE i,
             text   TYPE string,
           END OF ty_s_guglhupf,
           ty_t_guglhupf TYPE STANDARD TABLE OF ty_s_guglhupf.

    DATA: expected_structure TYPE ty_s_guglhupf,
          expected_table     TYPE ty_t_guglhupf,
          received_table     TYPE zif_yy_data_element=>ty_table,
          table_element      TYPE zif_yy_data_element=>ty_table_element,
          received_structure TYPE zif_yy_data_element=>ty_structure,
          structure_element  TYPE zif_yy_data_element=>ty_structure_element,
          received_number    TYPE i,
          received_string    TYPE string.

    expected_structure-number = 42.
    expected_structure-text   = 'Guglhupf'.
    INSERT expected_structure INTO TABLE expected_table.
    expected_structure-number = 23.
    expected_structure-text   = 'Käse'.
    INSERT expected_structure INTO TABLE expected_table.

    DATA(data_service) = zcl_yy_data_service=>create_instance_with_data( i_data = expected_table ).
    cl_abap_unit_assert=>assert_bound( data_service ).
    DATA(data_element) = data_service->get_element( ).
    data_element->get_value( IMPORTING e_value = received_table ).
    cl_abap_unit_assert=>assert_equals( exp = 2 act = lines( received_table ) ).
    READ TABLE received_table INTO table_element WITH TABLE KEY index = 2.
    table_element-element->get_value( IMPORTING e_value = received_structure ).
    READ TABLE received_structure INTO structure_element WITH TABLE KEY index = 1.
    structure_element-element->get_value( IMPORTING e_value = received_number ).
    cl_abap_unit_assert=>assert_equals( exp = expected_structure-number act = received_number ).
    READ TABLE received_structure INTO structure_element WITH TABLE KEY index = 2.
    structure_element-element->get_value( IMPORTING e_value = received_string ).
    cl_abap_unit_assert=>assert_equals( exp = expected_structure-text act = received_string ).


    DATA(descriptor) = data_element->get_descriptor( ).
    cl_abap_unit_assert=>assert_equals( exp = zif_yy_data_element_type=>table act = descriptor->get_type( )->get_type_name( ) ).
  ENDMETHOD.

  METHOD validate_object.
    DATA: actual_value TYPE string.

    DATA(my_object) = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element_type=>string ).
    DATA(data_service) = zcl_yy_data_service=>create_instance_with_data( i_data = my_object ).
    DATA(data_element) = data_service->get_element( ).
    data_element->get_value( IMPORTING e_value = actual_value ).
    cl_abap_unit_assert=>assert_equals( act = actual_value exp = zif_yy_data_element=>co_unsupported_element ).

    DATA(data_descriptor) = data_element->get_descriptor( ).
    cl_abap_unit_assert=>assert_equals( act = data_descriptor->get_name( ) exp = zif_yy_data_descriptor=>co_unnamed_object ).
    cl_abap_unit_assert=>assert_equals( act = data_descriptor->get_type( )->get_type_name( ) exp = zif_yy_data_element_type=>unsupported ).
  ENDMETHOD.

  METHOD crazy_json.

    DATA: crazy_json           TYPE string VALUE '[ { "one" : "eins", "three": "drei" }, { "one" : "uno", "two": "dos" } , { "three" : "tre", "four": "fire" } ]',
          actual_value         TYPE zif_yy_data_element=>ty_table,
          structure_descriptor TYPE REF TO zif_yy_data_struct_descriptor,
          structure_component  TYPE zif_yy_data_descriptor=>ty_struct_element_descriptor.

    DATA(data_service) = zcl_yy_data_service=>create_instance_with_json( i_json = crazy_json ).
    DATA(data_element) = data_service->get_element( ).
    data_element->get_value( IMPORTING e_value = actual_value ).
    cl_abap_unit_assert=>assert_equals( act = lines( actual_value ) exp = 3 ).

    structure_descriptor ?= data_element->get_descriptor( ).
    DATA(element_structure) = structure_descriptor->get_structure( ).
    cl_abap_unit_assert=>assert_equals( act = lines( element_structure ) exp = 4 ).
    READ TABLE element_structure INTO structure_component WITH TABLE KEY index = 1.
    cl_abap_unit_assert=>assert_equals( exp = 'one' act = structure_component-element->get_name( ) ).
    READ TABLE element_structure INTO structure_component WITH TABLE KEY index = 2.
    cl_abap_unit_assert=>assert_equals( exp = 'three' act = structure_component-element->get_name( ) ).
    READ TABLE element_structure INTO structure_component WITH TABLE KEY index = 3.
    cl_abap_unit_assert=>assert_equals( exp = 'two' act = structure_component-element->get_name( ) ).
    READ TABLE element_structure INTO structure_component WITH TABLE KEY index = 4.
    cl_abap_unit_assert=>assert_equals( exp = 'four' act = structure_component-element->get_name( ) ).

  ENDMETHOD.

ENDCLASS.
