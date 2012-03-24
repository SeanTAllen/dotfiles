# Copyright: Marcus Lindblom 2010
# License: GPLv2+
#
'''command that perform rebase or merge depending on the existance of merge conflicts

Provides the 'rebaseif' command that rebases if there are no conflicts and merges otherwise.
The reason for doing so is that a badly resolved conflict is easier to detect and fix afterwards
if it was merges, since the conflict resolution is explicit in a separate commit, rather than mashed
up with others as in the rebase case

Also adds a --rebaseif option to pull, similar to --rebase.
'''

# See http://stackoverflow.com/questions/4086724/how-do-i-check-for-potential-merge-rebase-conflicts-in-mercurial
# for some discussion on the matter

from mercurial import hg, commands, extensions, cmdutil
from mercurial.i18n import _

def rebaseif(ui, repo, **opts):
    '''rebases if there are no file conflicts and merges otherwise.

    See each command's documentation for details.
    '''

    # temporarly replace merge tool to try automatic rebase
    origmerge = ui.config('ui', 'merge')
    ui.setconfig('ui', 'merge', 'internal:fail')

    import hgext.rebase

    try:
        hgext.rebase.rebase(ui, repo)
        ui.status(_('rebaseif: successful rebase\n'))
        return 0
    except Exception, e:
        import traceback
        traceback.print_exc(e)
        hgext.rebase.rebase(ui, repo, abort=True)
    finally:
        ui.setconfig('ui', 'merge', origmerge)


    ui.status(_('rebaseif: failed to rebase, attempting merge\n'))

    import mercurial.commands
    mercurial.commands.merge(ui, repo)
    return 0


##############################################################################################

def pullrebaseif(orig, ui, repo, *args, **opts):
    '''Call rebaseif after pull if the latter has been invoked with --rebaseif'''
    # this function is taken in verbatim from rebase extension, with rebase replaced with rebaseif

    if opts.get('rebaseif'):
        if opts.get('update'):
            del opts['update']
            ui.debug(_('--update and --rebaseif are not compatible, ignoring the update flag\n'))

        try:
            cmdutil.bailifchanged(repo) # 1.9
        except AttributeError:
            cmdutil.bail_if_changed(repo) # < 1.9

        revsprepull = len(repo)
        origpostincoming = commands.postincoming
        def _dummy(*args, **kwargs):
            pass
        commands.postincoming = _dummy
        try:
            orig(ui, repo, *args, **opts)
        finally:
            commands.postincoming = origpostincoming
        revspostpull = len(repo)
        if revspostpull > revsprepull:
            rebaseif(ui, repo, **opts)
            branch = repo[None].branch()
            dest = repo[branch].rev()
            if dest != repo['.'].rev():
                # there was nothing to rebase we force an update
                hg.update(repo, dest)
    else:
        orig(ui, repo, *args, **opts)

##############################################################################################

def uisetup(ui):
    '''Replaces pull with a decorator to provide --rebaseif option'''

    entry = extensions.wrapcommand(commands.table, 'pull', pullrebaseif)
    entry[1].append(('', 'rebaseif', None,
                     _('rebase or merge working directory to branch head'))
)

##############################################################################################

cmdtable = {
    # 'command-name': (function-call, options-list, help-string)
    'rebaseif': (rebaseif, [], 'hg rebaseif')
}
