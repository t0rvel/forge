test_str = "case when  :27360105.29253414.29254014.2104232276904.12.205.2304114: is not null then pkg_os_lookup.fn_lookup_list_text_get ( 50 ,  :27360105.29253414.29254014.2104232276904.12.205.2304114: ) else '' end"


print(ord(''))

import json
from typing import Generator
import re

def rule_variable_members(pseudo_string: str) -> Generator:
    """
    method scope: using the pseudo code of a rule, return necessary variables which drive workflow Outcomes.
    :param pseudo_string: input parameter is the field value of B_RULE_SERIALIZED
    :return: generator object of variables
    """


    search_mechanism = re.compile(":(.+):")

    clean_pseudo_gen = (int(string_element.split('')[0].split('.')[-1]) for string_element
                         in pseudo_string.split(' ') if re.search(search_mechanism, string_element))

    return clean_pseudo_gen


print(json.dumps(list(rule_variable_members(test_str))))