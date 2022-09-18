# обработка файлов
import os


def start():
    # для ручного процесса тестирования
    # input("Загрузите файлы данных в папку data и нажмите продолжить: ")

    term_file = ''
    term_date = ''
    trans_file = ''
    trans_date = ''
    pass_file = ''
    pass_date = ''

    file_dir = os.path.dirname(__file__)
    list_dir = os.listdir(file_dir)
    print('Поиск файлов данных в директории ' + file_dir)

    for i in list_dir:
        i2 = i.split('_')
        if i2[0] == 'terminals':
            term_file = i
            date = i2[1].split('.')[0]
            term_date = date[4:] + '-' + date[2:4] + '-' + date[0:2]
            print("Файл " + term_file + " найден")
        elif i2[0] == 'transactions':
            trans_file = i
            date = i2[1].split('.')[0]
            trans_date = date[4:] + '-' + date[2:4] + '-' + date[0:2]
            print("Файл " + trans_file + " найден")
        elif i2[0] == 'passport':
            pass_file = i
            date = i2[2].split('.')[0]
            pass_date = date[4:] + '-' + date[2:4] + '-' + date[0:2]
            print("Файл " + pass_file + " найден")

    if term_file == '':
        print('Отсутвует файл "terminals"')
        # exit()
    elif trans_file == '':
        print('Отсутвует файл "transactions"')
        # exit()
    elif pass_file == '':
        print('Отсутвует файл "tassport_blacklist"')
        # exit()
    else:
        print('Выполнение ETL-процесса...')

    return term_file, trans_file, pass_file, term_date, trans_date, pass_date


# Удаление считанных файлов в архив
def file_del(dict_file):
    
    print('Загрузка данных в хранилище выполнена')

    file_dir = os.path.dirname(__file__)

    if 1 == 1:
        if dict_file['pass_file'] != '':
            os.rename(file_dir + '/' + dict_file['pass_file'],
                      file_dir + '/archive/' + dict_file['pass_file'] + '.baskup')
            print('Файл ' + dict_file['pass_file'] + ' перенесен в архив')

        if dict_file['term_file'] != '':
            os.rename(file_dir + '/' + dict_file['term_file'],
                      file_dir + '/archive/' + dict_file['term_file'] + '.baskup')
            print('Файл ' + dict_file['term_file'] + ' перенесен в архив')

        if dict_file['trans_file'] != '':
            os.rename(file_dir + '/' + dict_file['trans_file'],
                      file_dir + '/archive/' + dict_file['trans_file'] + '.baskup')
            print('Файл ' + dict_file['trans_file'] + ' перенесен в архив')
