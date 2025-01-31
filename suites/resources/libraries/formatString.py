import re

def removing_spaces(input_string):
    """
    Função para remover espaços de Strings
    """

    formatted_string = re.sub(r'\s+', '', input_string)

    print("Formatted string: ", formatted_string)
    
    return formatted_string
