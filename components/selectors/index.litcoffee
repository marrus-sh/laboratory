#  `/compontents/logic/selectors/index`  #

    import { createSelector } from 'reselect'
    import Immutable from 'immutable'

    getStatuses = (state) -> state.get('statuses')
    getAccounts = (state) -> state.get('accounts')

    getAccountBase         = (state, id) -> state.getIn(['accounts', id], null);
    getAccountRelationship = (state, id) -> state.getIn(['relationships', id]);

    export makeGetAccount = () -> createSelector(
        [getAccountBase, getAccountRelationship],
        (base, relationship) ->
            return null if base is null
            return base.set('relationship', relationship)
    )

    getStatusBase = (state, id) -> state.getIn(['statuses', id], null)

    export makeGetStatus = () -> createSelector(
        [getStatusBase, getStatuses, getAccounts],
        (base, statuses, accounts) ->
            return null if base is null
            return assembleStatus(base.get('id'), statuses, accounts)
    )

    assembleStatus = (id, statuses, accounts) ->
        status = statuses.get(id, null)
        reblog = null
        return null if status is null
        if status.get('reblog', null) isnt null
            reblog = statuses.get(status.get('reblog'), null);
            if reblog isnt null then reblog = reblog.set('account', accounts.get(reblog.get('account')))
            else return null
        return status.set('reblog', reblog).set('account', accounts.get(status.get('account')))

    getAlertsBase = (state) -> state.get('alerts');

    export getAlerts = createSelector(
        [getAlertsBase],
        (base) ->
            arr = [];
            base.forEach(item ->
                arr.push({
                    message: item.get('message')
                    title: item.get('title')
                    key: item.get('key')
                    dismissAfter: 5000
                })
            })
            return arr;

    export makeGetNotification = () -> createSelector(
        [
            (_, base)             -> base
            (state, _, accountId) -> state.getIn(['accounts', accountId])
        ],
        (base, account) -> base.set('account', account);
    )
