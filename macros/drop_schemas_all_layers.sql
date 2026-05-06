{% macro drop_schemas_all_layers(schema) %}

    {%- set dbs = [target.database, target.name ~ '_L1_STAGING', target.name ~ '_L2_INTEGRATION', target.name ~ '_L3_MART'] %}
    {% for db in dbs %}
        {{ drop_schema(db,schema) }}
    
    {% endfor %}
{% endmacro %}