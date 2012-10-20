# -*- coding: utf-8 -*-

# This software may be used and distributed according to the terms of the
# GNU General Public License version 2 or any later version.

# @author : yinwm <yinweiming@gmail.com>
# version 0.4

import os
import ConfigParser
            

from mercurial import commands
from mercurial import hg

from mercurial.i18n import _

BASIC_SECTION = 'Basic'
SECNAME_PUBLISH_BRANCH          = 'publish'
SECNAME_DEVELOP_BRANCH          = 'develop'
SECNAME_FEATURE_PREFIX          = 'feature'
SECNAME_RELEASE_PREFIX          = 'release'
SECNAME_HOTFIX_PREFIX           = 'hotfix'
SECNAME_VERSION_TAG_PREFIX      = 'version_tag'


class HgFlow(object):

    def __init__(self, ui, repo):
        self.ui = ui
        self.repo = repo

        self.rootDir = self.repo.root
        self.cfgFile = os.path.join(self.rootDir, '.hgflow')
        self.inited  = os.path.exists(self.cfgFile)

        if self.inited:
            config = ConfigParser.ConfigParser()
            config.read(self.cfgFile)

            self.publishBranch = config.get(BASIC_SECTION, SECNAME_PUBLISH_BRANCH)
            self.developBranch = config.get(BASIC_SECTION, SECNAME_DEVELOP_BRANCH)
            self.featurePrefix = config.get(BASIC_SECTION, SECNAME_FEATURE_PREFIX)
            self.releasePrefix = config.get(BASIC_SECTION, SECNAME_RELEASE_PREFIX)
            self.hotfixPrefix = config.get(BASIC_SECTION, SECNAME_HOTFIX_PREFIX)
            self.versionTagPrefix = config.get(BASIC_SECTION, SECNAME_VERSION_TAG_PREFIX)
            
        #self.output(self.rootDir, '\n', self.cfgFile, '\n', self.inited, '\n')

    def output(self, *args):
        for v in args:
            self.ui.write(v)
            
    def outputln(self, *args):
        args = args + ('\n',)
        self.output(*args)
        

    def input(self, msg):
        self.output(msg)
        return raw_input().strip()

    def _getBranchTags(self):
        d = self.repo.tags()
        #d = self.repo.branchtags()
        t = []
        for k, v in d.iteritems():
            t.append(k)
        return t
            #print v, type(v)

    def _getBranches(self):
        bmap = self.repo.branchmap()
        branches = []
        for b, h in bmap.iteritems():
            branches.append(b)
            #print self.repo.lookupbranch(b)

        return branches

    def _checkInited(self):
        if not self.inited:
            self.output(_('Your workspace is not inited with hg flow, use `hg flow init first`.'), '\n')
            return False

        return True


    def _hasUncommit(self):
        status = self.repo.status()
        for l in status:
            if len(l) > 0:
                self.outputln(_('Your workspace has uncommit content.'))
                return True

        return False


    def _createBranch(self, branch_name, message, from_branch = None):
        if not from_branch is None:
            #first update to from_branch
            commands.update(self.ui, self.repo, from_branch)
            
        commands.branch(self.ui, self.repo, branch_name)
        commands.commit(self.ui, self.repo, message = message)


    def hgflow_func_init(self, args, opts):
        if self.inited:
            self.output(_('Your workspace is already inited, use `hg flow check` for detail hg flow information'), '\n')
            return

        branches = self._getBranches()

        ctx = self.repo[None]
        current_branch = str(ctx.branch())
        

        if len(branches) > 1:
            #more than one brnach, give a warn
            self.output(_('You have more than one branches:'), '\n')
            for b in branches:
                self.output(b, '\t')
                if b != current_branch:
                    self.output('(inactive)')
                self.outputln()

            text = self.input(_('You want to continue flow init? [y] '))
            if not ('' == text or 'y' == text or 'yes' == text):
                return

        if self._hasUncommit():
            return

        publish_branch          = 'default'
        develop_branch          = 'develop'
        feature_branch_prefix   = 'feature/'
        release_branch_prefix   = 'release/'
        hotfix_branch_prefix    = 'hotfix/'
        version_tag_prefix      = ''

        text = self.input(_('Branch name for production release : [default] '))
        if text: publish_branch = text
        
        text = self.input(_('Branch name for "next release" development : [develop] '))
        if text: develop_branch = text

        self.output('\n', _('How to name your supporting branch prefixes?'), '\n');

        text = self.input(_('Feature branches? [feature/] '))
        if text: feature_branch_prefix = text
        text = self.input(_('Release branches? [release/] '))
        if text: release_branch_prefix = text
        text = self.input(_('Hotfix branches? [hotfix/] '))
        if text: hotfix_branch_prefix = text
        text = self.input(_('Version tag prefix? [] '))
        if text: version_tag_prefix = text

        #check existing branch
        
        import ConfigParser
        config = ConfigParser.RawConfigParser()

        config.add_section(BASIC_SECTION)
        config.set(BASIC_SECTION, SECNAME_PUBLISH_BRANCH,       publish_branch)
        config.set(BASIC_SECTION, SECNAME_DEVELOP_BRANCH,       develop_branch)
        config.set(BASIC_SECTION, SECNAME_FEATURE_PREFIX,       feature_branch_prefix)
        config.set(BASIC_SECTION, SECNAME_RELEASE_PREFIX,       release_branch_prefix)
        config.set(BASIC_SECTION, SECNAME_HOTFIX_PREFIX,        hotfix_branch_prefix)
        config.set(BASIC_SECTION, SECNAME_VERSION_TAG_PREFIX,   version_tag_prefix)

        configfile = open(self.cfgFile, 'wb')
        config.write(configfile)
        configfile.close()
        
        commands.add(self.ui, self.repo, self.cfgFile)
        commands.commit(self.ui, self.repo, self.cfgFile, message="hg flow init, add .hgflow file")

        if not publish_branch in branches:
            #create publish_branch
            self._createBranch(publish_branch, 'hg flow init, add branch %s' % (publish_branch, ))

        if not develop_branch in branches:
            self._createBranch(develop_branch, 'hg flow init, add branch %s' % (develop_branch, ))

    def _startBranch(self, target_branch, source_branch):
        branches = self._getBranches()
        #print target_branch, branches
        if target_branch in branches:
            self.outputln(_('Already has branch named `%s`' % (target_branch, )))
            return

        self._createBranch(target_branch, 'hg flow, add branch `%s`.' % (target_branch, ), source_branch)

    def _findBranch(self, target_branch, name):
        branches = self._getBranches()
        if not target_branch in branches:
            self.outputln(_('No such branch named `%s`' % (name,)))
            return False

        return True

    def _findTag(self, tag_name):
        tl = self._getBranchTags()
        if not tag_name in tl:
            self.outputln(_('No such tag named `%s`' % (tag_name,)))
            return False

        return True

    def hgflow_func_feature_finish(self, target_branch, name):
        '''finish this feature.
        1, Check develop branch version and current feature
        1, Close this branch
        2, Merge it into develop
        3, Commit develop branch
        '''

        if not self._findBranch(target_branch, name):
            return
        
        commands.update(self.ui, self.repo, target_branch)
        commands.commit(self.ui, self.repo, close_branch=True, message='hg flow, close feature %s' % (name,))

        commands.update(self.ui, self.repo, self.developBranch)
        commands.merge(self.ui, self.repo, target_branch)
        #commands.commit(self.ui, self.repo, message='hg flow, merge feature `%s` to develop branch `%s`' % (target_branch, self.developBranch))
        commands.commit(self.ui, self.repo, message='hg flow, merge release `%s` to develop branch `%s`' % (name, self.developBranch))
        #self.outputln(_('WARNING: No automatic commit after merge from feature `%s`, you should resolve the confict (if any) then commit manually.' % (name,)))

    def hgflow_func_release_finish(self, target_branch, name, tag_name):
        '''finish this releas
        1, Check publish branch version and current version
        2, Close this branch
        3, Merge it into publish branch
        4, Tag publish branch with release branch name
        5, Merge it into develop branch. Always not successed, should manully do that
        '''

        if not self._findBranch(target_branch, name):
            return
        if tag_name:
            if not self._findTag(tag_name):
                self.outputln(_('Tag `%s` not found.' % (tag_name,)))
                return
            else:
                self._mergeIntoPublishBranch(target_branch, name, tag_name)
        else:
             self._mergeIntoPublishBranch(target_branch, name)


    def hgflow_func_hotfix_finish(self, target_branch, name, tag_name):
        '''finish the hotfix
        1, Check publish branch version and current version
        2, Close this branch
        3, Merge it into publich branch
        4, Tag publish branch with hotfix branch name
        5, Merge it into develop branch. Always not successed, otherwise should manually do that
        '''
        if not self._findBranch(target_branch, name):
            return

        if tag_name:
            if not self._findTag(tag_name):
                self.outputln(_('Tag `%s` not found.' % (tag_name,)))
                return
            else:
                self._mergeIntoPublishBranch(target_branch, name, tag_name)
        else:
            self._mergeIntoPublishBranch(target_branch, name)

    def _mergeIntoPublishBranch(self, target_branch, name, source_tag_name = None):
        commands.update(self.ui, self.repo, target_branch)

        #tag for publish
        tag_name = '%s%s' % (self.versionTagPrefix, name)
        commands.tag(self.ui, self.repo, tag_name)
        
        commands.commit(self.ui, self.repo, close_branch=True, message='hg flow, close release %s' % (target_branch,))
        commands.update(self.ui, self.repo, self.publishBranch)

        self.outputln('Close branch `%s`' % (target_branch))

        #TODO: source_tag_name should in source_branch
        if source_tag_name:
            commands.merge(self.ui, self.repo, source_tag_name)
            self.outputln('Merge TAG `%s` into PRODCTION branch.' % (source_tag_name, ))
        else:
            commands.merge(self.ui, self.repo, target_branch)
            self.outputln('Merge BRANCH `%s` into PRODCTION branch.' % (target_branch, ))
            
        commands.commit(self.ui, self.repo, message='hg flow, merge release `%s` to publish branch `%s`' % (name, self.publishBranch))
        
        self.outputln('Merge BRANCH `%s` into DEVELOP branch.' % (target_branch, ))

        #merge it into develop branch, there should be many confilct code
        commands.update(self.ui, self.repo, self.developBranch)
        commands.merge(self.ui, self.repo, target_branch)
        commands.commit(self.ui, self.repo, message='hg flow, merge release `%s` to develop branch `%s`' % (name, self.developBranch))

        #self.outputln(_('WARNING: No automatic commit after merge from release `%s`, you should resolve the confict (if any) then commit manually' % (name, )))

    def hgflow_func_short(self, cmd, name, args, opts):
        if not self._checkInited():
            return
        
        if self._hasUncommit():
            return

        prefix = self.featurePrefix
        if cmd == 'hotfix':
            prefix = self.hotfixPrefix
        elif cmd == 'release':
            prefix = self.releasePrefix
            
        target_branch = '%s%s' % (prefix, name)
        tag_name = opts['rev']

        if not self._findBranch(target_branch, name):
            if not (opts['finish'] or opts['close'] or opts['switch']):
                if tag_name:
                    self.outputln(_('Start a new `%s` branch `%s` based on reversion `%s`' % (cmd, name, tag_name)))
                    self._startBranch(target_branch, tag_name)
                else:
                    '''
                    find the suit based branch
                    '''
                    if cmd == 'hotfix':
                        self.outputln(_('Start a new `%s` branch `%s` based on PUBLISH branch' % (cmd, name)))
                        self._startBranch(target_branch, self.publishBranch)
                    elif cmd == 'release' or cmd == 'feature':
                        self.outputln(_('Start a new `%s` branch `%s` based on DEVELOP branch' % (cmd, name)))
                        self._startBranch(target_branch, self.developBranch)
        else:
            if opts['finish']:
                '''
                find the suit based branch
                check the branches is already closed
                '''
                if cmd == 'hotfix':
                    self.hgflow_func_hotfix_finish(target_branch, name, tag_name)
                elif cmd == 'release':
                    self.hgflow_func_release_finish(target_branch, name, tag_name)
                elif cmd == 'feature':
                    self.hgflow_func_feature_finish(target_branch, name)
                    
            elif opts['close']:
                return
            else:
                #switch
                current_branch = hgflow_current_branch(self, prefix)
                if current_branch == name:
                    self.outputln(_('Already in `%s` branch `%s`, nothing happens.' % (cmd, name)))
                else:
                    self.outputln(_('Switch to `%s` branch `%s`.' % (cmd, name)))
                    commands.update(self.ui, self.repo, target_branch)

HGFLOW_FUNCTIONS = {
    'init'      : HgFlow.hgflow_func_init,
    'feature'   : HgFlow.hgflow_func_short,
    'release'   : HgFlow.hgflow_func_short,
    'hotfix'    : HgFlow.hgflow_func_short,
    }

def _fill_opts(opts, name, default = None):
    opts[name] = name in opts and opts[name] or None



def hgflow_cmd(ui, repo, cmd, *args, **opts):
    for o in ['start', 'switch', 'finish', 'close']:
        _fill_opts(opts, o)
    _fill_opts(opts, 'rev', '')

    if cmd == 'init' :
        hf = HgFlow(ui, repo)
        hf.hgflow_func_init(args, opts)
        
    elif cmd in HGFLOW_FUNCTIONS:
        if len(args) > 0:
            opts[args[0]] = True

        args = args[1:]
        name = args[0]

        hf = HgFlow(ui, repo)
        HGFLOW_FUNCTIONS[cmd](hf, cmd, name, args, opts)
    else:
        ui.write(_('Invalid command, use `hg flow --help` for detail information' ), '\n')

def hgflow_current_branch(hf, prefix):
    ctx = hf.repo[None] 
    current_branch = str(ctx.branch())
    name = current_branch.replace(prefix, '')
    if name == current_branch:
        return None
    return name
    
def hgfeature_cmd(ui, repo, *args, **opts):
    hf = HgFlow(ui, repo)
    if len(args) > 0 :
        name = args[0]
    else:
        name = hgflow_current_branch(hf, hf.featurePrefix)
        if name is None:
            self.outputln(_('Current branch is not feature branch'))
            return
    HgFlow.hgflow_func_short(hf, 'feature', name, args, opts)

def hgrelease_cmd(ui, repo, *args, **opts):
    hf = HgFlow(ui, repo)
    if len(args) > 0 :
        name = args[0]
    else:
        name = hgflow_current_branch(hf, hf.releasePrefix)
        if name is None:
            self.outputln(_('Current branch is not release branch'))
            return
        
    HgFlow.hgflow_func_short(hf, 'release', name, args, opts)

def hghotfix_cmd(ui, repo, *args, **opts):
    hf = HgFlow(ui, repo)
    #print args
    if len(args) > 0 :
        name = args[0]
    else:
        name = hgflow_current_branch(hf, hf.hotfixPrefix)
        if name is None:
            self.outputln(_('Current branch is not hotfix branch'))
            return

    HgFlow.hgflow_func_short(hf, 'hotfix', name, args, opts)
    
    '''
    print ui
    print repo
    print patch
    print args
    print opts
    '''



cmdtable = {
    'flow' : (
      (
        hgflow_cmd,
        [ ('h', 'help', None, 'Help' ),
          ('r', 'rev',  '',   'The specified revision'), ],
        ('hg flow ')
        )
      ),
    'feature' : (
      hgfeature_cmd,
      [ ('c', 'close',  None, 'close the branch'),
        ('s', 'switch', None, 'switch the branch'),
        ('r', 'rev',    '',   'The specified revision'),
        ('f', 'finish', None, 'finish the branch') ],
      ('hg feature [options] [branch_name]')
      ),
    'release' : (
      hgrelease_cmd,
      [ ('c', 'close',  None, 'close the branch'),
        ('s', 'switch', None, 'switch the branch'),
        ('r', 'rev',    '',   'The specified revision'),
        ('f', 'finish', None, 'finish the branch') ],
      ('hg release [options] [branch_name]')
      ),
    'hotfix' : (
      hghotfix_cmd,
      [ ('c', 'close',  None, 'Close the branch'),
        ('s', 'switch', None, 'Switch the branch'),
        ('r', 'rev',    '',   'The specified revision'),
        ('f', 'finish', None, 'Finish the branch') ],
      ('hg hotfix [options] [branch_name]')
      )
    }
