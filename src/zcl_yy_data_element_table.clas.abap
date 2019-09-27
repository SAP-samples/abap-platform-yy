CLASS zcl_yy_data_element_table DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES: zif_yy_data_element, zif_yy_data_element_builder.
    CLASS-METHODS: create_instance RETURNING VALUE(r_data_element) TYPE REF TO zcl_yy_data_element_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      constructor,
      build_descriptor IMPORTING i_current_name TYPE string.
    DATA: my_value      TYPE zif_yy_data_element=>ty_table,
          my_descriptor TYPE REF TO zif_yy_data_descriptor.
ENDCLASS.



CLASS zcl_yy_data_element_table IMPLEMENTATION.


  METHOD build_descriptor.

    DATA: structure_element_descriptor TYPE zif_yy_data_descriptor=>ty_struct_element_descriptor,
          structure_descriptor         TYPE zif_yy_data_descriptor=>ty_structure_descriptor,
          completed_names              TYPE string_table,
          current_index                TYPE i.

    LOOP AT my_value INTO DATA(value_element).
      DATA(element_descriptor) = value_element-element->get_descriptor( ).
      IF element_descriptor->get_type( )->get_type_name( ) = zif_yy_data_element_type=>structure OR
         element_descriptor->get_type( )->get_type_name( ) = zif_yy_data_element_type=>table.
        DATA(line_descriptor) = CAST zif_yy_data_struct_descriptor( element_descriptor ).
        DATA(line_structure) = line_descriptor->get_structure( ).
        LOOP AT line_structure INTO DATA(line_element).
          IF NOT line_exists( completed_names[ table_line = line_element-element->get_name( ) ] ).
            ADD 1 TO current_index.
            CLEAR: structure_element_descriptor.
            structure_element_descriptor-index   = current_index.
            structure_element_descriptor-element = line_element-element.
            INSERT structure_element_descriptor INTO TABLE structure_descriptor.
            INSERT line_element-element->get_name( ) INTO TABLE completed_names.
          ENDIF.
        ENDLOOP.
      ELSE.
        " We assume a list of simple elements, therefore taking the first one... :)
        ADD 1 TO current_index.
        CLEAR: structure_element_descriptor.
        structure_element_descriptor-index   = current_index.
        structure_element_descriptor-element = value_element-element->get_descriptor( ).
        INSERT structure_element_descriptor INTO TABLE structure_descriptor.
        my_descriptor = zcl_yy_data_struct_descriptor=>create_instance( i_name                 = structure_element_descriptor-element->get_name( )
                                                                        i_type                 = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element_type=>table )
                                                                        i_structure_descriptor = structure_descriptor ).
        RETURN.
      ENDIF.
    ENDLOOP.

    IF structure_descriptor IS NOT INITIAL.
      my_descriptor = zcl_yy_data_struct_descriptor=>create_instance( i_name                 = i_current_name
                                                                      i_type                 = zcl_yy_data_element_type=>create_instance( i_type_name = zif_yy_data_element_type=>table )
                                                                      i_structure_descriptor = structure_descriptor ).
    ENDIF.

  ENDMETHOD.


  METHOD constructor.
    zif_yy_data_element~type = zif_yy_data_element_type=>table.
  ENDMETHOD.


  METHOD create_instance.
    r_data_element = NEW #( ).
  ENDMETHOD.


  METHOD zif_yy_data_element_builder~build.

    DATA: current_data_element  TYPE REF TO zif_yy_data_element,
          current_name          TYPE string,
          current_index         TYPE i VALUE 0,
          current_table_element TYPE zif_yy_data_element=>ty_table_element.

    CLEAR: my_value, my_descriptor.

    DO.
      DATA(current_node) = i_data_reader->read_next_node( ).
      IF current_node IS INITIAL.
        RETURN.
      ENDIF.
      IF current_node->type = if_sxml_node=>co_nt_element_open.

        ADD 1 TO current_index.
        IF i_data_reader->value IS INITIAL.
          current_name = zif_yy_data_descriptor=>co_unnamed_object.
        ELSE.
          current_name = i_data_reader->value.
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

        current_table_element-index = current_index.
        current_table_element-element = current_data_element.
        INSERT current_table_element INTO TABLE my_value.

      ENDIF.
      IF current_node->type = if_sxml_node=>co_nt_element_close.
        DATA(close_element) = CAST if_sxml_close_element( current_node ).
        DATA(node_name) = close_element->if_sxml_named~qname-name.
        IF node_name = zif_yy_data_element_type=>table.
          EXIT.
        ENDIF.
      ENDIF.
    ENDDO.

    build_descriptor( i_current_name = i_element_name ).

  ENDMETHOD.


  METHOD zif_yy_data_element~get_descriptor.
    r_descriptor = my_descriptor.
  ENDMETHOD.


  METHOD zif_yy_data_element~get_value.
    e_value = my_value.
  ENDMETHOD.
ENDCLASS.
