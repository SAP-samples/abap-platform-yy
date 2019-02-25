INTERFACE zif_yy_data_element_type
  PUBLIC .

  TYPES: ty_type TYPE string.

  CONSTANTS: number      TYPE ty_type VALUE 'num',
             string      TYPE ty_type VALUE 'str',
             structure   TYPE ty_type VALUE 'object',
             table       TYPE ty_type VALUE 'array',
             unsupported TYPE ty_type VALUE 'unsupported'.

  METHODS: get_type_name RETURNING VALUE(r_type_name) TYPE ty_type.

ENDINTERFACE.
