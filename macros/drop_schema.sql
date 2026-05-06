{% macro drop_schema(db ,schema) %}
    {% do log('dropping schema ' ~ db ~ '.' ~ schema, info=True) %}
    {% set sql %}
        drop schema if exists {{ db }}.{{ schema }} cascade;
    {% endset %}
    {% do run_query(sql) %}

{% endmacro %}