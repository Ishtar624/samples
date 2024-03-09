import telebot
from telebot import types
from random import randint

from bs4 import BeautifulSoup
import requests

dw_news = {
    'news': [],
    'links': [],
    'summary': [],
    'date': []
}
url = 'https://www.doctorwhotv.co.uk/news'
response = requests.get(url)
bs = BeautifulSoup(response.text, 'lxml')
temp = bs.find_all('div', class_='post-content')
for post in temp:
    dw_news['news'].append(post.find('h2', class_='post-title entry-title').text)
    dw_news['links'].append(post.find('h2', class_='post-title entry-title').find('a').get('href'))
    dw_news['summary'].append(post.find('div', class_='entry-content').text.replace('\n',''))
    dw_news['date'].append(post.find('span', class_='year').text)

dw_facts = ['The show first aired on November 23, 1963, the day after the assassination of John F. Kennedy.', 'The TARDIS is stuck in the shape of a 1960s British police box, because its “chameleon circuit” is broken.', 'The Doctor’s home planet, Gallifrey, is located in the constellation of Kasterborous.', 'K-9, a robotic dog, was a companion of the Fourth Doctor and later appeared in the spin-off series The Sarah Jane Adventures.', 'The Doctor’s preferred method of transportation when not using the TARDIS is a vintage British car called “Bessie,” first introduced during the Third Doctor’s era.', 'Peter Capaldi, who played the Twelfth Doctor, is a lifelong fan of Doctor Who and even wrote a fan letter to the Radio Times when he was 15 years old.', 'The Doctor has a fondness for jelly babies, a British candy, which was especially popular during the Fourth Doctor’s era.', 'The Doctor has a complicated relationship with the Time Lords, often criticizing their bureaucracy and rigid adherence to the Laws of Time.', 'The Tenth Doctor’s catchphrase “Allons-y” is French for “Let’s go.”', 'Many episodes of Doctor Who from the 1960s are considered “lost” due to the BBC’s policy of wiping tapes at the time. Efforts have been made to recover and reconstruct these missing episodes using audio recordings and still images.']

TOKEN = '6962612147:AAFzt1g9KQeHWF6-ocub9owfzgNKmRDe4dU'

bot = telebot.TeleBot(TOKEN)

@bot.message_handler(commands=['start'])
def start(message):

    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    btn1 = types.KeyboardButton('WHAT? Who are you?')
    markup.add(btn1)

    bot.send_message(message.chat.id,
                     f'''Nice to meet you, <b>{message.from_user.first_name}</b>! Run for your life!''',
                     parse_mode='html', reply_markup=markup)

@bot.message_handler(content_types=['text']) #'WHAT? Who are you?', 'Back in console room'])
def hello(message):
    if message.text == 'WHAT? Who are you?' or 'Back in console room':
        inline = types.InlineKeyboardMarkup()
        button_1 = types.InlineKeyboardButton('Ask about TV show', callback_data='about')
        button_2 = types.InlineKeyboardButton('Latest news', callback_data='news')
        button_3 = types.InlineKeyboardButton('Random DW fact', callback_data='fact')
        inline.add(button_1, button_2, button_3)
        bot.send_message(message.chat.id, f'''Okay, we are in TARDIS console room! And... Well, <i>safe</i>, I think? I am her text interface or <b>{bot.get_me().first_name}</b> bot for your human mind. I can guide you through the whole whoniverse! Allons-y!''', parse_mode='html', reply_markup=inline)
    
@bot.callback_query_handler(func=lambda call: True)
def callback_inline(call):
    
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    btnBack = types.KeyboardButton('Back in console room')
    markup.add(btnBack)
    
    if call.data == 'about':
        bot.send_message(call.message.chat.id, 'Fantastic! So! Doctor Who is a British television series created and controlled by the BBC. It centres on a time traveller called "the Doctor", who is coming from a race known as Time Lords. They travel through space and time with their companions in a time machine they call the TARDIS and accidentally save the world every saturday evening.', reply_markup=markup)
    elif call.data == 'news':
        new_news = ''
        for i in range(0, len(dw_news['news'])):
            new_news += f'''<b>{i+1}</b> <a href="{dw_news['links'][i]}">{dw_news['news'][i]}</a>\n{dw_news['summary'][i]} <i>{dw_news['date'][i]}</i>\n\n'''
        bot.send_message(call.message.chat.id, f'''Time... So here are the latest news:\n {new_news}''', parse_mode='html', reply_markup=markup) #dw_news
    elif call.data == 'fact':
        t = randint(0, 9)
        one_fact = ''+ dw_facts[t]
        bot.send_message(call.message.chat.id, f'''Fact from TARDIS library:\n {one_fact}''', parse_mode='html', reply_markup=markup)

bot.polling(non_stop=True)
