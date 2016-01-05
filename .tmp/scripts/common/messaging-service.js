(function() {
  angular.module('smartRegisterApp').factory('MessagingService', [
    '$rootScope', '$filter', function($rootScope, $filter) {
      return {
        resetMessages: function() {
          $rootScope.showMessages = false;
          $rootScope.messages = [];
          return $rootScope.filteredMessages = [];
        },
        createMessage: function(type, message, groupName, linkUrl, linkText) {
          message = {
            type: type,
            text: message,
            group: groupName,
            linkUrl: linkUrl,
            linkText: linkText
          };
          return message;
        },
        addMessage: function(message) {
          return $rootScope.messages.push(message);
        },
        removeMessage: function(message) {
          var index;
          index = $rootScope.messages.indexOf(message);
          return $rootScope.messages.splice(index, 1);
        },
        hasMessages: function(group) {
          if (group != null) {
            $rootScope.filteredMessages = this.getMessagesByGroup(group);
            $rootScope.showMessages = true;
          } else {
            $rootScope.filteredMessages = $rootScope.messages;
          }
          if ($rootScope.filteredMessages.length) {
            $rootScope.showMessages = true;
          } else {
            $rootScope.showMessages = false;
          }
          return $rootScope.filteredMessages;
        },
        hasErrors: function() {
          var errors;
          errors = this.getMessagesByType('error');
          if (errors.length) {
            $rootScope.showMessages = true;
          }
          return errors;
        },
        getLocalizedMessage: function(key, args) {
          return $rootScope.$localeService.ready("messages").then(function() {
            return $rootScope.$localeService.getString(key, args);
          });
        },
        getMessagesByType: function(type) {
          return $rootScope.filteredMessages = _.filter($rootScope.messages, function(it) {
            return it.type === type;
          });
        },
        getMessagesByValue: function(value) {
          return $rootScope.filteredMessages = _.filter($rootScope.messages, function(it) {
            return it.message === value;
          });
        },
        getMessagesByGroup: function(group) {
          return _.filter($rootScope.messages, function(it) {
            return it.group === group;
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=messaging-service.js.map
