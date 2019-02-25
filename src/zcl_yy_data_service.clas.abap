CLASS zcl_yy_data_service DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS: create_instance_with_data IMPORTING i_data                TYPE any
                                             RETURNING VALUE(r_data_service) TYPE REF TO zcl_yy_data_service,
      create_instance_with_json IMPORTING i_json                TYPE string
                                RETURNING VALUE(r_data_service) TYPE REF TO zcl_yy_data_service
                                RAISING   zcx_yy_unsupported_data.

    METHODS:
      get_element RETURNING VALUE(r_element) TYPE REF TO zif_yy_data_element.
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS:
      constructor IMPORTING i_data_reader TYPE REF TO if_sxml_reader,
      determine_root_element IMPORTING i_data_reader TYPE REF TO if_sxml_reader,
      initialize_unsupported_element.

    DATA: my_element TYPE REF TO zif_yy_data_element.
ENDCLASS.



CLASS zcl_yy_data_service IMPLEMENTATION.


  METHOD constructor.

    determine_root_element( i_data_reader = i_data_reader ).

  ENDMETHOD.


  METHOD create_instance_with_data.

    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
    CALL TRANSFORMATION id SOURCE yy = i_data RESULT XML json_writer.
    DATA(json_code) = cl_abap_conv_codepage=>create_in( )->convert( source = json_writer->get_output( ) ).
    DATA(data_reader) = cl_sxml_string_reader=>create( input = json_writer->get_output( ) ).

    r_data_service = NEW #( i_data_reader = data_reader ).
  ENDMETHOD.


  METHOD determine_root_element.

    DATA: element_name TYPE string VALUE zif_yy_data_descriptor=>co_unnamed_object.

    TRY.
        DO.
          DATA(current_node) = i_data_reader->read_next_node( ).
          IF current_node IS INITIAL.
            EXIT.
          ENDIF.

          IF current_node->type = if_sxml_node=>co_nt_element_open AND i_data_reader->value = zif_yy_data_descriptor=>co_unnamed_object.
            " Depending on the type of the first element, we initialize our root element
            CASE i_data_reader->name.
              WHEN zif_yy_data_element_type=>table.
                my_element = zcl_yy_data_element_table=>create_instance(  ).
              WHEN zif_yy_data_element_type=>structure.
                my_element = zcl_yy_data_element_structure=>create_instance(  ).
              WHEN zif_yy_data_element_type=>string.
                my_element = zcl_yy_data_element_string=>create_instance(  ).
              WHEN zif_yy_data_element_type=>number.
                my_element = zcl_yy_data_element_number=>create_instance(  ).
              WHEN OTHERS.
                " Somewhen...
            ENDCASE.
            TRY.
                CAST zif_yy_data_element_builder( my_element )->build( i_data_reader  = i_data_reader
                                                                       i_element_name = element_name ).
              CATCH zcx_yy_unsupported_data.
                me->initialize_unsupported_element( ).
            ENDTRY.
            EXIT.
          ENDIF.
        ENDDO.
      CATCH cx_sxml_parse_error.
        CLEAR: my_element.
    ENDTRY.
  ENDMETHOD.


  METHOD get_element.

    r_element = my_element.

  ENDMETHOD.


  METHOD initialize_unsupported_element.
    my_element = NEW lcl_data_element_unsupported( ).
  ENDMETHOD.

  METHOD create_instance_with_json.
    DATA: yy_json TYPE string.

    yy_json = |\{ "{ zif_yy_data_descriptor=>co_unnamed_object }" : { i_json } \}|.

    TRY.
        DATA(data_reader) = cl_sxml_string_reader=>create( input = cl_abap_conv_codepage=>create_out( )->convert( source = yy_json ) ).
        r_data_service = NEW #( i_data_reader = data_reader ).
      CATCH cx_sy_conversion_codepage INTO DATA(conversion_error).
        RAISE EXCEPTION TYPE zcx_yy_unsupported_data.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
