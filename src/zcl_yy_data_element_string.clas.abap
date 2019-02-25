CLASS zcl_yy_data_element_string DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES: zif_yy_data_element, zif_yy_data_element_builder.
    CLASS-METHODS: create_instance RETURNING VALUE(r_data_element) TYPE REF TO zcl_yy_data_element_string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: constructor.
    DATA: my_value      TYPE string,
          my_descriptor TYPE REF TO zcl_yy_data_descriptor.
ENDCLASS.



CLASS ZCL_YY_DATA_ELEMENT_STRING IMPLEMENTATION.


  METHOD constructor.
    zif_yy_data_element~type = zif_yy_data_element_type=>string.
  ENDMETHOD.


  METHOD create_instance.
    r_data_element = NEW #( ).
  ENDMETHOD.


  METHOD zif_yy_data_element_builder~build.

    CLEAR: my_value, my_descriptor.

    DO.
      DATA(current_node) = i_data_reader->read_next_node( ).
      IF current_node IS INITIAL.
        RETURN.
      ENDIF.
      IF current_node->type = if_sxml_node=>co_nt_value.
        my_value = i_data_reader->value.
        EXIT.
      ENDIF.
    ENDDO.

    my_descriptor = zcl_yy_data_descriptor=>create_instance( i_name = i_element_name
                                                             i_type = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element~type ) ).
  ENDMETHOD.


  METHOD zif_yy_data_element~get_descriptor.
    r_descriptor = my_descriptor.
  ENDMETHOD.


  METHOD zif_yy_data_element~get_value.
    e_value = my_value.
  ENDMETHOD.
ENDCLASS.
