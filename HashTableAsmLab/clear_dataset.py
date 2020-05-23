import re
file = open('newstest2011.txt', encoding="utf8")
a = file.read()

f_file = open('formatted_newstest2011.txt', 'w')
words = set()

for word in a.lower().split():
    word = re.sub('<\w*>', "", word)
    word = re.sub('docid=\w*', "", word)
    word = re.sub('\w*-2010-\w*', "", word)
    word = re.sub('seg', "", word)
    word = word.replace(".", "")
    word = word.replace(",", "")
    word = word.replace(":", "")
    word = word.replace("\"", "")
    word = word.replace("/", " ")
    word = word.replace("!", "")
    word = word.replace("*", "")
    word = word.replace("<", "")
    word = word.replace(">", "")
    word = word.replace("“", "")
    word = word.replace(";", "")
    word = word.replace("?", "")
    word = word.replace("(", "")
    word = word.replace(")", "")
    if word != "":
        words.add(word)

for word in words:
    f_file.write(word + '\n')

file.close()
