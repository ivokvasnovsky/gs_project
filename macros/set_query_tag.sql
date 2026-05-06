{% macro set_query_tag() %}
    {% set tag = {
        "env": target.name,
        "model": model.name,
        "invocation_id": invocation_id
    } %}
    
    ALTER SESSION SET QUERY_TAG = '{{ tag | tojson }}';
{% endmacro %}