"use strict"

app = angular.module "app.services"

app.service 'UserService', [
    "$http"
    "UserAuthFactory"
    "UserUniquenessFactory"
    "$rootScope"
    "$log"
    "$q"
    "Base64"
    "$cookieStore"
    "$state"
    ($http, UserAuthFactory, UserUniquenessFactory, $rootScope, $log, $q, Base64, $cookieStore, $state) ->
        class User
            # @method constructor
            # @public
            constructor: ->
                @user = {}

            # @method checkUniqueness
            # @public
            # @param {String} key
            # @param {String} value
            checkUniqueness: (key, value) ->
                $log.info "UserService checkUniqueness called"
                $log.debug
                    key: key
                    value: value

                params = {}
                params[key] = escape(value)

                UserUniquenessFactory.check(params).$promise.then (results) ->
                    $log.info "UserService checkUniqueness success (user does not exist)"
                    $log.debug
                        results: results

                    if results["available"]
                        $q.resolve(results)
                    else
                        $q.reject(results)
                , (error) ->
                    $log.error "UserService checkUniqueness get error (user exists already)"
                    $log.debug
                        error: error

                    $q.reject(error)

            # @method logon
            # @public
            # @param {String} user
            logon: (user) =>
                $log.info "UserService logon called"
                $log.debug
                    name: user.name

                deferred = $q.defer()

                authData = Base64.encode(user.name + ":" + user.password)
                $http.defaults.headers.common["Authorization"] = "Basic " + authData

                UserAuthFactory.get().$promise.then (result) =>
                    $log.info "UserService init success called"
                    $log.debug
                        result: result

                    @user = result.user
                    @setCredentials(@user.name, @user._id, authData)

                    deferred.resolve @user

                    @redirect()

                , (error) =>
                    $log.info "UserService init error of authorization called (401)"
                    $log.debug
                        error: error

                    @logout()

                    deferred.reject error

                deferred.promise

            # @method logout
            # @public
            logout: =>
                $log.info "UserService logout called"

                @user =
                    name: ""

                $rootScope.globals.authorized = undefined
                delete $rootScope.globals.currentUser

                $cookieStore.remove "globals"

                $http.defaults.headers.common.Authorization = "Basic "

                if $state.$current.name is "app.profile"
                    $state.go "app.index"

            # @method setCredentials
            # @public
            # @param {String} name
            # @param {String} userID
            setCredentials: (name, userID, authData) ->
                $log.info "UserService setCredentials called"
                $log.debug
                    name: name
                    userID: userID

                $rootScope.globals =
                    currentUser:
                        name: name
                        authData: authData
                        id: userID
                $cookieStore.put "globals", $rootScope.globals
                $rootScope.globals.authorized = true

            # @method redirect
            # @public
            # @description redirect user to last visited pages before login-/ registration-page was entered;
            # @description redirect to app.index if visited pages were only app.login or app.registration
            redirect: ->
                # After login success we want to route the user to the last page except login and registration
                for element, index in $rootScope.history
                    element = $rootScope.history[$rootScope.history.length - (index + 1)]

                    if element.name isnt "app.login" and element.name isnt "app.registration" and element.name isnt ""
                        $log.info "UserService redirect to " + element.name

                        # redirect to detailview needs vidatio-id, so an additional if is necessary to transfer the id
                        if element.name is "app.dataset"
                            $state.go element.name, 'id': element.params.id, element.params.locale
                            return

                        $state.go element.name, element.params.locale
                        return

                $state.go "app.index"

        new User
]
