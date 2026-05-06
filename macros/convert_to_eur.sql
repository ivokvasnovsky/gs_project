{%- macro convert_to_eur(columns, rate_col) -%}
    
    {%- if columns is string -%}
        {%- set columns = [columns] -%}
    {%- endif -%}
    
    {%- for column in columns -%}
        {%- set alias = column.split('.')[-1] ~ '_EUR' -%}
        round(
            {{ column }} * coalesce({{ rate_col }}, 1),
            2
        ) as {{ alias }}
        {%- if not loop.last %},
        {% endif -%}
    {%- endfor -%}
{%- endmacro -%}