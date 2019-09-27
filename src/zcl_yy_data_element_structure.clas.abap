CLASS zcl_yy_data_element_structure DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES: zif_yy_data_element, zif_yy_data_element_builder.
    CLASS-METHODS: create_instance RETURNING VALUE(r_data_element) TYPE REF TO zcl_yy_data_element_structure.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      constructor,
      append_structure_descriptor IMPORTING i_current_index        TYPE i
                                            i_current_data_element TYPE REF TO zif_yy_data_element
                                  CHANGING  c_structure_descriptor TYPE zif_yy_data_descriptor=>ty_structure_descriptor.
    DATA: my_value      TYPE zif_yy_data_element=>ty_structure,
          my_descriptor TYPE REF TO zcl_yy_data_struct_descriptor.
    CONSTANTS: co_reference_identifier TYPE string VALUE '%ref'.
ENDCLASS.



CLASS zcl_yy_data_element_structure IMPLEMENTATION.


  METHOD constructor.
    zif_yy_data_element~type = zif_yy_data_element_type=>structure.
  ENDMETHOD.


  METHOD create_instance.
    r_data_element = NEW #( ).
  ENDMETHOD.


  METHOD zif_yy_data_element_builder~build.

    DATA: current_data_element TYPE REF TO zif_yy_data_element,
          current_name         TYPE string,
          current_index        TYPE i VALUE 0,
          structure_descriptor TYPE zif_yy_data_descriptor=>ty_structure_descriptor,
          is_open              TYPE abap_bool.

    CLEAR: my_value, my_descriptor.

    DO.
      DATA(current_node) = i_data_reader->read_next_node( ).
      IF current_node IS INITIAL.
        RETURN.
      ENDIF.
      IF current_node->type = if_sxml_node=>co_nt_element_open.
        IF is_open = abap_true.
          append_structure_descriptor( EXPORTING i_current_index        = current_index
                                                 i_current_data_element = current_data_element
                                       CHANGING  c_structure_descriptor = structure_descriptor ).
        ENDIF.
        is_open = abap_true.
        ADD 1 TO current_index.
        IF i_data_reader->value IS INITIAL.
          current_name = i_element_name.
        ELSE.
          current_name = i_data_reader->value.
        ENDIF.
        IF current_name = co_reference_identifier.
          RAISE EXCEPTION TYPE zcx_yy_unsupported_data.
        ENDIF.
        CASE i_data_reader->name.
          WHEN zif_yy_data_element_type=>table.
            current_data_element = zcl_yy_data_element_table=>create_instance(  ).
          WHEN zif_yy_data_element_type=>structure.
            current_data_element = zcl_yy_data_element_structure=>create_instance(  ).
          WHEN zif_yy_data_element_type=>string.
            current_data_element = zcl_yy_data_element_string=>create_instance(  ).
          WHEN zif_yy_data_element_type=>number.
            current_data_element = zcl_yy_data_element_number=>create_instance(  ).
          WHEN OTHERS.
            " Somewhen...
        ENDCASE.
        CAST zif_yy_data_element_builder( current_data_element )->build( i_data_reader  = i_data_reader
                                                                         i_element_name = current_name ).
      ENDIF.
      IF current_node->type = if_sxml_node=>co_nt_element_close.
        is_open = abap_false.
        IF current_data_element IS NOT BOUND.
          RETURN.
        ENDIF.
        append_structure_descriptor( EXPORTING i_current_index        = current_index
                                               i_current_data_element = current_data_element
                                     CHANGING  c_structure_descriptor = structure_descriptor ).
        IF i_data_reader->name = zif_yy_data_element_type=>structure.
          EXIT.
        ENDIF.
      ENDIF.
    ENDDO.

    my_descriptor = zcl_yy_data_struct_descriptor=>create_instance( i_name                 = i_element_name
                                                                    i_type                 = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element~type )
                                                                    i_structure_descriptor = structure_descriptor ).

  ENDMETHOD.


  METHOD zif_yy_data_element~get_descriptor.
    r_descriptor = my_descriptor.
  ENDMETHOD.


  METHOD zif_yy_data_element~get_value.
    e_value = my_value.
  ENDMETHOD.


  METHOD append_structure_descriptor.

    DATA: current_structure_element  TYPE zif_yy_data_element=>ty_structure_element,
          current_element_descriptor TYPE zif_yy_data_descriptor=>ty_struct_element_descriptor.

    IF i_current_data_element IS NOT BOUND.
      RETURN.
    ENDIF.
    current_structure_element-index   = i_current_index.
    current_structure_element-element = i_current_data_element.
    INSERT current_structure_element INTO TABLE my_value.
    current_element_descriptor-index   = i_current_index.
    current_element_descriptor-element = i_current_data_element->get_descriptor( ).
    INSERT current_element_descriptor INTO TABLE c_structure_descriptor.

  ENDMETHOD.

ENDCLASS.
