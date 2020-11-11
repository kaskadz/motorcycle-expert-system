from pyswip import Prolog

knowledge_base_file = r'motorcycle_knowledge_base.pl'
form_file = r'form.txt'

if __name__ == '__main__':
    prolog = Prolog()
    prolog.consult(knowledge_base_file)

    with open(form_file, 'r') as f:
        for line in f.readlines():
            premise_type, value = line.split(' ')
            next(prolog.query(f'save({premise_type}, {value})'))

    print('State:')
    for x in prolog.query('ans(X, Y)'):
        print(x['X'], x['Y'])

    print('Suggestions:')
    for x in prolog.query('motorcycle(X)'):
        print(f' - {x["X"]}')
