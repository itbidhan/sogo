/* -*- Mode: javascript; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* JavaScript for common UI services */

(function() {
    'use strict';

    /**
     * @name Dialog (sgDialog factory in SOGo.UIDesktop)
     * @desc Dialog object constructor
     */
    function Dialog() {
    }

    /**
     * @name alert
     * @desc Show an alert dialog box with a single "OK" button
     * @param {string} title
     * @param {string} content
     */
    Dialog.alert = function(title, content) {
        var modal = this.$modal.open({
            template: 
              '<h2 data-ng-bind-html="title"></h2>' +
              '<p data-ng-bind-html="content"></p>' +
              '<a class="button button-primary" ng-click="closeModal()">' + l('OK') + '</a>' +
              '<span class="close-reveal-modal" ng-click="closeModal()"><i class="icon-close"></i></span>',
            windowClass: 'small',
            controller: function($scope, $modalInstance) {
                $scope.title = title;
                $scope.content = content;
                $scope.closeModal = function() {
                    $modalInstance.close();
                };
            }
        });
    };

    /**
     * @name confirm
     * @desc Show a confirmation dialog box with buttons "Cancel" and "OK"
     * @param {string} title
     * @param {string} content
     * @returns a promise that always resolves, but returns true only if the user user has clicked on the
     * 'OK' button
     */
    Dialog.confirm = function(title, content) {
        var d = this.$q.defer();
        var modal = this.$modal.open({
            template: 
              '<h2 data-ng-bind-html="title"></h2>' +
              '<p data-ng-bind-html="content"></p>' +
              '<a class="button button-primary" ng-click="confirm()">' + l('OK') + '</a>' +
              '<a class="button button-secondary" ng-click="closeModal()">' + l('Cancel') + '</a>' +
              '<span class="close-reveal-modal" ng-click="closeModal()"><i class="icon-close"></i></span>',
            windowClass: 'small',
            controller: function($scope, $modalInstance) {
                $scope.title = title;
                $scope.content = content;
                $scope.closeModal = function() {
                    $modalInstance.close();
                    d.resolve(false);
                };
                $scope.confirm = function() {
                    $modalInstance.close();
                    d.resolve(true);
                };
            }
        });
        return d.promise;
    };

    /* The factory we'll use to register with Angular */
    Dialog.$factory = ['$modal', '$q', function($modal, $q) {
        angular.extend(Dialog, { $modal: $modal, $q: $q });

        return Dialog; // return constructor
    }];

    /* Angular module instanciation */
    angular.module('SOGo.UIDesktop', ['mm.foundation'])

    /* Factory registration in Angular module */
    .factory('sgDialog', Dialog.$factory);
})();