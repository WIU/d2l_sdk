#!/usr/local/bin/python3
#!/usr/local/bin/python2.7
#demo_beaker.py

import urllib.parse
import beaker.middleware
import bottle
from bottle import request, route, hook, template, redirect, abort

import d2lvalence.auth as d2lauth
import d2lvalence_util.data as d2ldata
import d2lvalence_util.service as d2lservice

from conf_basic import app_config as _CFG

_AUTH_ROUTE = '/token'
_AUTH_CB = '{0}://{1}:{2}{3}'.format(_CFG['scheme'], _CFG['host'], _CFG['port'], _AUTH_ROUTE)

_ac = d2lauth.fashion_app_context(app_id = _CFG['app_id'], app_key = _CFG['app_key'])
_session_opts = {'session.type':'memory', 'session.auto': True}
_app = beaker.middleware.SessionMiddleware(bottle.app(), _session_opts)

@hook('before_request')
def _setup_request():
    request.session = request.environ['beaker.session']

@route('/ping')
@route('/ping/')
@route('/ping/<name:re:[a-zA-Z0-9]+>')
def ping(name='World'):
    assert name.isalnum()
    return template('<b>Ping! Hello {{name}}!</b>', name=name)

@route('/')
@route('/start')
def start():
    if 'user_context' not in request.session:
        aurl = _ac.create_url_for_authentication(
            host = _CFG['lms_host'],
            client_app_url = _AUTH_CB,
            encrypt_request = _CFG['encrypt_requests'])
        return template('needsAuth', aurl=aurl)
    else:
        redirect('/whoami', 302)

@route(_AUTH_ROUTE, method='GET')
def auth_token_handler():
    uc = _ac.create_user_context(
        result_uri = request.url,
        host = _CFG['lms_host'],
        encrypt_requests = _CFG['encrypt_requests'])
    request.session['user_context'] = uc.get_context_properties()
    redirect('/whoami', 302)

@route('/whoami', method='GET')
def whoami_handler():
    if 'user_context' not in request.session:
        aurl = _ac.create_url_for_authentication(
            host = _CFG['lms_host'],
            client_app_url = _AUTH_CB,
            encrypt_request = _CFG['encrypt_requests'])
    else:
        uc = _ac.create_user_context(
            d2l_user_context_props_dict = request.session['user_context'])

        user = d2lservice.get_whoami(uc, ver = _CFG['lms_ver']['lp'], verify = _CFG['verify'])

    return template('whoami', first_name = user.FirstName, last_name = user.LastName)

bottle.run(app = _app, host = _CFG['host'], port = _CFG['port'], debug = _CFG['debug'])