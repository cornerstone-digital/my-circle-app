angular.module('smartRegisterApp')
.factory 'MessagingService', ['$rootScope', '$filter', ($rootScope, $filter) ->
  resetMessages: ->
    $rootScope.showMessages = false
    $rootScope.messages = []
    $rootScope.filteredMessages = []

  createMessage: (type, message, groupName, linkUrl, linkText) ->

    # accepted types ['info','warning','success','error']
    message = {type: type, text: message, group: groupName, linkUrl: linkUrl, linkText: linkText}

    return message

  addMessage: (message) ->
    $rootScope.messages.push(message)

  removeMessage: (message) ->
    index = $rootScope.messages.indexOf(message)
    $rootScope.messages.splice index, 1

  hasMessages: (group) ->
    if group?
      $rootScope.filteredMessages = @getMessagesByGroup(group)
      $rootScope.showMessages = true
    else
      $rootScope.filteredMessages = $rootScope.messages

    if $rootScope.filteredMessages.length
      $rootScope.showMessages = true
    else
      $rootScope.showMessages = false

    return $rootScope.filteredMessages

  hasErrors: ->
    errors = @getMessagesByType('error')

    if errors.length
      $rootScope.showMessages = true

    return errors

  getLocalizedMessage: (key, args) ->
    $rootScope.$localeService.ready("messages").then(->
      return $rootScope.$localeService.getString(key, args)
    )

  getMessagesByType: (type) ->
    $rootScope.filteredMessages = _.filter $rootScope.messages, (it) -> it.type is type

  getMessagesByValue: (value) ->
    $rootScope.filteredMessages = _.filter $rootScope.messages, (it) -> it.message is value

  getMessagesByGroup: (group) ->
    _.filter $rootScope.messages, (it) -> it.group is group
]