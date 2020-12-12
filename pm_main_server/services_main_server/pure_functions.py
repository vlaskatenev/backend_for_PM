
def to_one_index_pwsh(short_program_name, soft_display_name, program_file, key_string, url_to_programm_file):
    obj_for_powershell = f"@{{ShortProgrammName=\"{short_program_name}\"\n"\
        f"softDisplayName=\"{soft_display_name}\"\n"\
        f"ProgrammFile=\"{program_file}\"\n"\
        f"key=\"{key_string}\"\n"\
        f"urlToProgrammFile=\"{url_to_programm_file}\"}}"
    return obj_for_powershell

    
def create_object_for_powershell(array_with_dict):
    array_with_dict = [to_one_index_pwsh(one_dict['short_program_name'],
    one_dict['soft_display_name'], one_dict['program_file'], one_dict['key_string'], one_dict['url_to_programm_file']) for one_dict in array_with_dict]
    return str(f"$programms = @({', '.join(array_with_dict)})\n"\
               "$idInstall = *******")


def create_file_ps1(obj_powershell, computer_name, id_install):
    path = f"/usr/src/scripts/forClients/{computer_name}.ps1"
    object_for_computer = obj_powershell.replace('*******', str(id_install))
    # создание файла
    script_file = open(path, 'tw', encoding='utf-8-sig')
    script_file.write(object_for_computer)
    script_file.close()


def to_id_install_from_db():
    pass