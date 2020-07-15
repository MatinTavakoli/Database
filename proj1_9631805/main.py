import psycopg2
import time
import sys
from prettytable import PrettyTable

def print_psycopg2_exception(err):
    err_type, err_obj, traceback = sys.exc_info()
    line_num = traceback.tb_lineno
    print ("\npsycopg2 ERROR:", err, "on line number:", line_num)
    print ("psycopg2 traceback:", traceback, "-- type:", err_type)
    print ("\nextensions.Diagnostics:", err.diag)
    print ("pgerror:", err.pgerror)
    print ("pgcode:", err.pgcode, "\n")

def show_commands():
    print('################################################################################')
    print('sign up                          creating a foofle email')
    print('sign in                          signing into your foofle account')
    print('get notifications                get all notifications for your account')
    print('get account data                 receive account data(including both personal and system data)')
    print('get other account data           receive someone else\'s account data(if possible)')
    print('edit account                     edit current account')
    print('send email                       sending an email')
    print('get sent emails                  receive all emails that you sent')
    print('get inbox emails                 receive all emails sent to your account')
    print('read email                       read a received email')
    print('delete email                     delete an email(received or sent)')
    print('delete account                   delete current account')
    print('-help                            shows all available commands')
    print('-exit                            exits foofle email system')
    print('################################################################################')

config = {
  'database': 'postgres',
  'user': 'postgres',
  'password': '5VL98WX24',
  'host': '127.0.0.1',
  'port': '5432'
}
con = psycopg2.connect(**config)
cursor = con.cursor()

print('welcome to the foofle email system!')
time.sleep(2)
while(True):
    print('select a command:\n'
          '1. sign up\n'
          '2. sign in\n'
          '3. get notifications\n'
          '4. get account data\n'
          '5. get other account data\n'
          '6. edit account\n'
          '7. send email\n'
          '8. get sent emails\n'
          '9. get inbox emails\n'
          '10. read email\n'
          '11. delete email\n'
          '12. delete account\n'
          '13. help\n'
          '14. exit\n')
    time.sleep(2)
    print('please enter your command.\nto see a full list of commands, select 13 for help.\n')
    command = int(input())
    if command == 1:
        try:
            print('uname: ')
            uname = str(input())
            print('password: ')
            password = str(input())
            print('system phone number: ')
            system_phone_number = str(input())
            print('address: ')
            address = str(input())
            print('firstname: ')
            firstname = str(input())
            print('lastname: ')
            lastname = str(input())
            print('personal phone number: ')
            personal_phone_number = str(input())
            print('date of birth: ')
            date_of_birth = str(input())
            print('known as: ')
            known_as = str(input())
            print('id: ')
            id = str(input())
            print('default access: ')
            default_access = str(input())
            cursor.execute('SELECT sign_up(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')' % (uname, password, system_phone_number, address, firstname, lastname, personal_phone_number, date_of_birth, known_as, id, default_access))
            con.commit()
            print('sign up successful!')
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 2:
        try:
            print('uname: ')
            uname = str(input())
            print('password: ')
            password = str(input())
            cursor.execute('SELECT sign_in(\'%s\', \'%s\')' % (uname, password))
            con.commit()
            print('sign in successful!')
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 3:
        try:
            cursor.execute('SELECT * FROM get_notifications()')
            table = PrettyTable()
            table.field_names = ['username', 'message', 'time']
            rows = cursor.fetchall()
            for row in rows:
                table.add_row(row)
            print(table)
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 4:
        try:
            cursor.execute('SELECT * FROM get_account_data()')
            table = PrettyTable()
            table.field_names = ['username', 'reg date', 'system phone number', 'address', 'firstname', 'lastname',
                                 'personal phone number', 'date of birth', 'known as', 'id', 'default access']
            row = cursor.fetchone()
            table.add_row(row)
            print(table)
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 5:
        try:
            print('uname: ')
            uname = str(input())
            cursor.execute('SELECT * FROM get_other_account_data(\'%s\')' % (uname))
            con.commit()
            table = PrettyTable()
            table.field_names = ['username', 'address', 'firstname', 'lastname',
                                 'personal phone number', 'date of birth', 'known as', 'id', 'default access']
            row = cursor.fetchone()
            table.add_row(row)
            print(table)
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 6:
        try:
            print('new password: ')
            new_password = str(input())
            print('new system phone number: ')
            new_system_phone_number = str(input())
            print('new address: ')
            new_address = str(input())
            print('new firstname: ')
            new_firstname = str(input())
            print('new lastname: ')
            new_lastname = str(input())
            print('new personal phone number: ')
            new_personal_phone_number = str(input())
            print('new date of birth: ')
            new_date_of_birth = str(input())
            print('new known as: ')
            new_known_as = str(input())
            print('new id: ')
            new_id = str(input())
            print('new default access: ')
            new_default_access = str(input())
            cursor.execute(
                'SELECT edit_account(\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\')' % (
                new_password, new_system_phone_number, new_address, new_firstname, new_lastname, new_personal_phone_number, new_date_of_birth,
                new_known_as, new_id, new_default_access))
            con.commit()
            print('edit successful!')
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 7:
        try:
            print('subject: ')
            subject = input()
            print('message: ')
            message = input()
            print('recipient_list: ')
            recipients = ''
            recipient = input()
            if recipient != '':
                recipients += '\''
                recipients += recipient
                recipients += '\''
            recipient = input()
            while (recipient != ''):
                recipients += (', \'' + recipient)
                recipients += '\''
                recipient = input()
            query = 'SELECT send_email(' + '\'' + subject + '\'' + ', ' + '\'' + message + '\'' + ', ' + recipients + ')'
            cursor.execute(query)
            con.commit()
            print('email sent!')
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 8:
        try:
            print('limit: ')
            limit = int(input())
            print('page: ')
            page = int(input())
            cursor.execute('SELECT * FROM get_sent_emails(\'%s\', \'%s\')' % (limit, page))
            table = PrettyTable()
            table.field_names = ['id', 'subject', 'time', 'message', 'is deleted']
            rows = cursor.fetchall()
            for row in rows:
                table.add_row(row)
            print(table)
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 9:
        try:
            print('limit: ')
            limit = int(input())
            print('page: ')
            page = int(input())
            cursor.execute('SELECT * FROM get_inbox_emails(\'%s\', \'%s\')' % (limit, page))
            table = PrettyTable()
            table.field_names = ['id', 'sender_email', 'subject', 'time', 'message', 'is_read', 'is_deleted']
            rows = cursor.fetchall()
            for row in rows:
                table.add_row(row)
            print(table)
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 10:
        try:
            print('id: ')
            id = int(input())
            cursor.execute('SELECT * FROM read_email(\'%s\')' % (id))
            con.commit()
            table = PrettyTable()
            table.field_names = ['id', 'sender_email', 'subject', 'time', 'message', 'is_read', 'is_deleted']
            row = cursor.fetchone()
            table.add_row(row)
            print(table)
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()


    elif command == 11:
        try:
            print('id: ')
            id = int(input())
            cursor.execute('SELECT * FROM delete_email(\'%s\')' % (id))
            con.commit()
            print('email deleted!')
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 12:
        try:
            cursor.execute('SELECT * FROM delete_account()')
            con.commit()
            print('account deleted completely!')
            time.sleep(2)
        except Exception as err:
            print_psycopg2_exception(err)
            con.rollback()

    elif command == 13:
        print('list of all commands:')
        show_commands()

    elif command == 14:
        print('exiting...')
        time.sleep(2)
        sys.exit()
    else:
        print('nonsense!')
    time.sleep(2)
    print('\n')

cursor.close()
cnx.close()