(function(){angular.module("msfEbola",["ngAnimate","ngCookies","ngTouch","ngSanitize","ui.router","ui.bootstrap","leaflet-directive","pascalprecht.translate","ngSocial","cfp.hotkeys","btford.markdown"])}).call(this),function(){angular.module("msfEbola").filter("stripTags",function(){return function(t,e){return null==e&&(e=""),String(t).replace(/<[^>]+>/gm,e)}})}.call(this),function(){var t=function(t,e){return function(){return t.apply(e,arguments)}};angular.module("msfEbola").factory("Share",["$modal",function(e){var a;return new(a=function(){function a(){this.close=t(this.close,this),this.open=t(this.open,this)}return a.prototype.open=function(){return this.close(),this.modalInstance=e.open({templateUrl:"components/share/share.html",controller:"ShareCtrl",size:"lg"})},a.prototype.close=function(){return null!=this.modelInstance?this.modelInstance.close():void 0},a}())}])}.call(this),function(){angular.module("msfEbola").controller("ShareCtrl",["$scope","$modalInstance","$state",function(t,e,a){return t.close=e.close,t.getIframe=function(){var t,e,n;return e=a.href("introduction",{},{absolute:!0}),n="100%",t=650,'<iframe src="'+e+'" width="'+n+'" height="'+t+'" frameborder="0" allowfullscreen></iframe>'}}])}.call(this),function(){var t=function(t,e){return function(){return t.apply(e,arguments)}};angular.module("msfEbola").factory("Progress",function(){var e;return new(e=function(){function e(){this.complete=t(this.complete,this),this.start=t(this.start,this),this.toggle=t(this.toggle,this),this.body=angular.element("body"),this.body.append('<div class="progress-container"><div class="progress-container__spinner"><div></div>'),this.progress=angular.element(".progress-container")}return e.prototype.toggle=function(t){return this.state=t,this.progress.toggleClass("progress-container--active",t),this.body.toggleClass("body--progress-active",t)},e.prototype.start=function(){return this.toggle(!0)},e.prototype.complete=function(){return this.toggle(!1)},e}())})}.call(this),function(){angular.module("msfEbola").controller("MenuCtrl",["$scope","$translate","$state","index","Share",function(t,e,a,n,i){return t.languages=n.languages.sort(),t.useLanguage=function(a){return e.use(a),t.showLanguages=!1},t.share=i.open,t.isAnimating=!1,t.$on("main:play",function(){return t.isAnimating=!0}),t.$on("main:end",function(){return t.isAnimating=!1}),t.$on("main:skip",function(){return t.isAnimating=!1})}])}.call(this),function(){angular.module("msfEbola").directive("draggable",["$document",function(t){return{restrict:"AE",require:"ngModel",link:function(e,a,n,i){var s,l,r,o,c,u,_;return o=a.parent(),u=_=c=0,s=function(t){return 0===t.type.indexOf("touch")},l=function(t){var e;return e=s(t)?t.originalEvent.touches[0]:t,_=e.pageX-u,c=_/o.width()*100,c=Math.max(Math.min(c,100),0),a.css({left:c+"%"}),i.$setViewValue(c)},r=function(){return t.off("mousemove touchmove",l),t.off("mouseup touchend",r)},e.$watch(n.ngModel,function(t){return _=(t||0)/100*o.width(),a.css({cursor:"move",left:(t||0)+"%"})}),a.on("mousedown touchstart",function(e){var a;return e.preventDefault(),_=(i.$viewValue||0)/100*o.width(),a=s(e)?e.originalEvent.touches[0]:e,u=a.pageX-_,t.on("mousemove touchmove",l),t.on("mouseup touchend",r)})}}}])}.call(this),function(){angular.module("msfEbola").filter("decimal",["$translate",function(t){return function(e,a){return null==e&&(e=""),null==a&&(a=t.instant("decimal_mark")),(e+"").replace(/\./,a)}}])}.call(this),function(){angular.module("msfEbola").filter("decade",function(){return function(t){return null==t&&(t=0),10*Math.round(t/10)}})}.call(this),function(){angular.module("msfEbola").filter("addTargetBlank",function(){return function(t){var e;return e=angular.element("<div>"+t+"</div>"),e.find("a").attr("target","_blank"),angular.element("<div>").append(e).html()}})}.call(this),function(){angular.module("msfEbola").config(["$stateProvider",function(t){return t.state("main",{params:{skip:{value:0}},templateUrl:"app/main/main.html",controller:"MainCtrl",resolve:{highlights:["$http",function(t){return t.get("assets/json/highlights.json",{cache:!0}).then(function(t){var e,a,n,i;for(i=t.data,a=0,n=i.length;n>a;a++)e=i[a],e.date_start=new Date(e.date_start).getTime();return t.data})}],days:["$http",function(t){return t.get("assets/json/days.json",{cache:!0}).then(function(t){return t.data})}],aggregation:["$http",function(t){return t.get("assets/json/aggregation.json",{cache:!0}).then(function(t){return t.data})}],centers:["$http",function(t){return t.get("assets/json/centers.json",{cache:!0}).then(function(t){return t.data})}]}})}])}.call(this),function(){angular.module("msfEbola").directive("main",["$rootScope","$state","main",function(t,e,a){return{restrict:"C",require:"ngModel",link:function(n,i,s,l){var r,o,c,u,_,d;return r=i.find(".main__timeline__anchor"),_=r.parent(),c=0,o=function(){return r.css("left").replace("px","")/_.width()},d=function(){return r.velocity({left:"100%"},{duration:(1-o())*a.duration,easing:"linear",progress:function(){var t,e;return t=o(),e=~~(365*t),e>c?(l.$setViewValue(100*t),l.$render(),c=e):void 0},complete:function(){return t.$apply(function(){return t.$broadcast("main:end")})}})},n.$on("main:play",d),n.$on("main:cancel",function(){return r.velocity("stop")}),n.$on("main:skip",function(){return r.velocity("stop")}),u="1"===e.params.skip?"main:skip":"main:play",t.$broadcast(u)}}}])}.call(this),function(){angular.module("msfEbola").controller("MainCtrl",["$scope","$rootScope","$compile","$stateParams","$timeout","leafletData","main","days","aggregation","centers","highlights",function(t,e,a,n,i,s,l,r,o,c,u){var d,m,g,p,f,h,v,b,w,y,k,$;for(d=function(e){var a,n,i;if(null!=t.day&&null!=t.day.centers[e.name])return"support"===e.type?e.icon=l.iconSupport:(n=t.day.centers[e.name],i=Math.ceil(n.staff_count/5),a=Math.ceil(n.weekly_new_confirmed_smoothed/5),e.icon=angular.extend(angular.copy(l.iconCte),{html:l.iconCte.template({open:""+n.is_open,name:e.name,staff:Array(i+1).join('<i class="fa fa-male"></i>'),admitted:Array(a+1).join('<i class="fa fa-male"></i>')})})),e},b=function(e,n){return t.isAnimating?void 0:s.getMap().then(function(e){var i,s,r,o,u;return i=c[n.markerName],o=L.latLng(i.lat,i.lng),s=L.popup().setLatLng(o).openOn(e),u=t.$new(!1),angular.extend(u,{center:i}),u.$watch("today",function(){return angular.extend(u.center,t.day.centers[i.name])}),r=angular.element(s._contentNode),r.html(l.centerPopup),a(r)(u)})},t.isAnimating=!0,t.highlights=u,t.months=l.months,t.progress=0,t.day=null,t.weeks=o.weeks,t.weeksCount=o.weeksCount,t.monthTicks=[],t.final=l.final,k=new Date(o.start),p=new Date(o.end),g=o.end-o.start,$=f=w=k.getFullYear(),y=p.getFullYear();y>=w?y>=f:f>=y;$=y>=w?++f:--f)for(v=h=0;11>=h;v=++h)($===k.getFullYear()&&v>=k.getMonth()||$===p.getFullYear()&&v<=p.getMonth()||$!==k.getFullYear()&&$!==p.getFullYear())&&(m=new Date($,v+1),t.monthTicks.push((m.getTime()-k.getTime())/g));return t.settings=l.settings,t.progressFilter=function(e){return(e+1)/o.weeksCount<=t.progress/100},t.highlightFilter=function(e){return e.date_start<=t.today.getTime()&&e.date_start+864e5>=t.today.getTime()&&t.isAnimating},t.lastHighlight=function(){return _.find(u,t.highlightFilter)},t.progressDate=function(){var e;return k=new Date(l.start.getTime()),e=7*o.weeksCount*t.progress/100,k.setDate(k.getDate()+e),k},t.figureStyle=function(t){var e;return e=l.final.death_total+l.final.cases_total+l.final.confirmed_msf+l.final.treated_msf,{width:Math.round(t/e*100)+"%"}},t.popoverFilter=function(t){var e;return(null!=(e=t.weekly_new_cases)?e:0)>0},t.$watch("progress",function(){var a,n,s,l,o;for(t.today=t.progressDate(),a=t.today.getTime()/1e3,t.day=null,l=0,o=r.length;o>l&&(n=r[l],!(1*n.timestamp>a));l++)t.day=n;return t.centers=_.map(c,d),t.centers=_.filter(t.centers,function(t){return null!=t}),s=t.lastHighlight(),null!=s&&t.highlight!==s?(e.$broadcast("main:cancel"),t.highlight=s,i(function(){return e.$broadcast("main:play")},s.duration)):void 0}),t.$on("leafletDirectiveMarker.click",b),t.$on("main:play",function(){return t.isAnimating=!0}),t.$on("main:end",function(){return t.isAnimating=!1,t.displayFinalHighlight=!0}),t.$on("main:skip",function(){return t.isAnimating=!1,t.displayFinalHighlight=!1})}])}.call(this),function(){angular.module("msfEbola").constant("main",{start:new Date(2014,2,17),duration:35e3,months:["january","february","march","april","may","june","july","august","september","october","november","december"],iconCte:{type:"div",className:"main__map__center main__map__center--cte",iconSize:[20,20],popupAnchor:[0,0],template:_.template(['<div class="main__map__center__wrapper" data-name="<%- name %>" data-open="<%- open %>">','<i class="main__map__center__marker fa fa-dot-circle-o"></i>','<div class="main__map__center__staff"><%= staff %></div>','<div class="main__map__center__admitted"><%= admitted %></div>',"</div>"].join(""))},iconSupport:{type:"div",className:"main__map__center main__map__center--support",iconSize:[30,30],popupAnchor:[0,0],html:'<i class="main__map__center__marker fa fa-circle"></i>'},centerPopup:"<div ng-include=\"'app/main/popup/popup.html'\"></div>","final":{cases_total:24666,death_total:10179,confirmed_msf:4963,treated_msf:2329},settings:{maxbounds:{southWest:L.latLng(90,180),northEast:L.latLng(-90,-180)},center:{zoom:7,lat:8.8,lng:-11.7},defaults:{maxZoom:7,minZoom:7,zoomControl:!1,scrollWheelZoom:!1},tiles:{name:"CartoDB.Positron",type:"sxyz",url:"https://a.tiles.mapbox.com/v3/mapbox.world-light/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoianBsdXNwbHVzIiwiYSI6ImtUcW9EMlkifQ.xWvwXs8dsVHnIvpDXkGvEg",options:{attribution:'&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',subdomains:"abcd",minZoom:0,maxZoom:18,continuousWorld:!1,noWrap:!0}}}})}.call(this),function(){angular.module("msfEbola").animation(".victims-animation",function(){var t;return t=function(t,e,a){var n,i;return i=t.find(".main__weeks__slot__outline__victim"),n=500/i.length,i.stop().css({opacity:1-e}),i.each(function(t){var a;return a=t*n,$(this).delay(a).velocity({opacity:e},{duration:100,easing:"linear"})}),setTimeout(a,500)},{beforeAddClass:function(e,a,n){"ng-hide"===a&&t(e,0,n)},beforeRemoveClass:function(e,a,n){"ng-hide"===a?t(e,1,n):n()}}})}.call(this),function(){angular.module("msfEbola").config(["$stateProvider",function(t){return t.state("introduction",{url:"/?lang",templateUrl:"app/introduction/introduction.html",controller:"IntroductionCtrl",params:{step:null,url:null},resolve:{preload:["$q","$http",function(t,e){return t.all([e.get("assets/json/days.json",{cache:!0}),e.get("assets/json/highlights.json",{cache:!0}),e.get("assets/json/centers.json",{cache:!0}),e.get("assets/json/aggregation.json",{cache:!0})])}]}})}])}.call(this),function(){angular.module("msfEbola").controller("IntroductionCtrl",["$scope","$stateParams","$state","$translate","hotkeys",function(t,e,a,n,i){return t.step=e.step||0,t.next=function(){return t.step<3?t.step++:a.go("main")},null!=e.lang&&n.use(e.lang),i.add({combo:["space","right"],description:"Go to the next screen.",callback:t.next})}])}.call(this),function(){angular.module("msfEbola").config(["$stateProvider",function(t){return t.state("about",{templateUrl:"app/about/about.html"})}])}.call(this),function(){angular.module("msfEbola").config(["$translateProvider","index",function(t,e){return t.useStaticFilesLoader({prefix:"assets/json/",suffix:".json"}).registerAvailableLanguageKeys(e.languages).determinePreferredLanguage().fallbackLanguage(["en"]).useCookieStorage()}])}.call(this),function(){angular.module("msfEbola").config(["$urlRouterProvider","$locationProvider",function(t,e){return t.otherwise("/"),e.hashPrefix("!"),e.html5Mode(!1)}]).run(["$rootScope","Progress","$location","$window",function(t,e,a,n){return t.$on("$stateChangeStart",function(){return $("body").scrollTo(0,400),e.start()}),t.$on("$stateChangeSuccess",function(){return e.complete(),null!=n.ga?n.ga("send","pageview",{page:a.url()}):void 0}),t.$on("$stateChangeError",e.complete)}])}.call(this),function(){angular.module("msfEbola").constant("index",{languages:["de","en","fr","sv","es","da","zh"]})}.call(this),angular.module("msfEbola").run(["$templateCache",function(t){t.put("app/about/about.html",'<div class="about"><a ui-sref="main({skip: 1})" class="btn btn-primary btn-sm"><i class="fa fa-arrow-left"></i>&nbsp; {{ \'back_to_map\' | translate }}</a><h2 class="about__title">{{ \'about_title\' | translate }}</h2><article btf-markdown="\'about_body\' | translate" class="about__body"></article></div>'),t.put("app/introduction/introduction.html",'<div ng-switch="step" ng-class="\'introduction--step-\' + step" class="introduction"><div ng-switch-when="0" class="introduction__step"><p>{{ \'introduction_1\' | translate }}</p><div class="text-center"><a ng-click="next()" class="introduction__step__next"><i class="fa fa-arrow-circle-right fa-2x"></i></a></div></div><div ng-switch-when="1" class="introduction__step"><p>{{ \'introduction_2\' | translate }}</p><div class="text-center"><a ng-click="next()" class="introduction__step__next"><i class="fa fa-arrow-circle-right fa-2x"></i></a></div></div><div ng-switch-when="2" class="introduction__step"><p>{{ \'introduction_3\' | translate }}</p><div class="text-center"><a ng-click="next()" class="introduction__step__next"><i class="fa fa-arrow-circle-right fa-2x"></i></a></div></div><div ng-switch-when="3" class="introduction__step"><p>{{ \'introduction_4\' | translate }}</p><div class="text-center"><a ng-click="next()" class="introduction__step__next"><i class="fa fa-arrow-circle-right fa-2x"></i></a></div></div></div>'),t.put("app/main/main.html",'<div ng-model="progress" ng-class="{ \'main--animating\': isAnimating }" class="main"><leaflet center="settings.center" markers="centers" tiles="settings.tiles" maxbounds="settings.maxbounds" defaults="settings.defaults" class="main__map"></leaflet><div class="main__legend"><ul class="list-unstyled"><li class="main__legend__item"><i class="fa fa-fw fa-dot-circle-o text-success"></i><span ng-bind-html="\'center\' | translate"></span></li><li class="main__legend__item main__legend__item--staff"><i class="fa fa-fw fa-male text-success"></i><span ng-bind-html="\'five_staff\' | translate"></span></li><li class="main__legend__item"><i class="fa fa-fw fa-male text-primary"></i><span ng-bind-html="\'five_admitted\' | translate"></span></li></ul></div><div class="main__highlights"><div ng-repeat="highlight in ::highlights" ng-show="highlightFilter(highlight)" class="main__highlights__item"><div class="main__highlights__item__wrapper"><div ng-bind-html="highlight.translation_key | translate | addTargetBlank"></div></div></div><div ng-show="displayFinalHighlight" class="main__highlights__item"><div class="main__highlights__item__wrapper"><div ng-bind-html="\'final_highlight\' | translate | addTargetBlank"></div><div class="text-center"><a ng-click="displayFinalHighlight = false" class="btn btn-primary">{{ \'explore_data\' | translate }}</a></div></div></div></div><div class="main__chart"><div ng-style="figureStyle(final.death_total)" class="main__chart__stack main__chart__stack--dead"><span class="main__chart__stack__figure"><span ng-bind-html="&quot;dead&quot; | translate: { death_total: (final.death_total | decade) }"></span></span></div><div ng-style="figureStyle(final.cases_total)" class="main__chart__stack main__chart__stack--case"><span class="main__chart__stack__figure"><span ng-bind-html="&quot;cases&quot; | translate: { cases_total: (final.cases_total | decade) }"></span></span></div><div ng-style="figureStyle(final.confirmed_msf)" class="main__chart__stack main__chart__stack--msf-admitted"><span class="main__chart__stack__figure"><span ng-bind-html="&quot;admitted_by_msf&quot; | translate: { admitted_msf_cumulative: (final.confirmed_msf | decade) }"></span></span></div><div ng-style="figureStyle(final.treated_msf)" class="main__chart__stack main__chart__stack--msf-cured"><span class="main__chart__stack__figure"><span ng-bind-html="&quot;cured_by_msf&quot; | translate: { recovered_msf_cumulative: (final.treated_msf | decade) }"></span></span></div></div><div ng-mouseenter="showLastSlot = true" ng-mouseleave="showLastSlot = false" class="main__timeline"><div ng-style="{ width: progress + \'%\' }" class="main__timeline__cursor"></div><div draggable="draggable" ng-model="progress" data-month="{{ months[today.getMonth()] | translate }}" class="main__timeline__anchor">{{ today.getDate() }}</div><div class="main__timeline__months"><div ng-repeat="month in ::monthTicks" ng-style="{ left: month * 100 + \'%\' }" class="main__timeline__months__month"></div></div></div><div ng-class="{ \'main__weeks--active\': showLastSlot }" class="main__weeks"><div class="main__weeks__legend">{{ "new_weekly_cases" | translate }}<p ng-hide="isAnimating" class="main__weeks__legend__launch-animation"><a ui-sref="main({skip: 0})" ui-sref-opts="{ reload: true }" class="btn btn-primary btn-sm"><i class="fa fa-play-circle-o"></i>&nbsp; {{ \'launch_animation\' | translate }}</a></p></div><div ng-repeat="week in ::weeks" ng-class="{ \'main__weeks__slot--last\': progressFilter($index) &amp;&amp; !progressFilter($index + 1) }" class="main__weeks__slot"><div class="main__weeks__slot__outline"><div ng-show="progressFilter($index)" class="victims-animation"><div ng-repeat="victim in ::week.victims track by $index" class="main__weeks__slot__outline__victim"></div></div><div class="clearfix"></div><div ng-class="{ \'main__weeks__slot__outline__popover--rtl\': $index &lt; weeksCount/3 }" class="main__weeks__slot__outline__popover"><h4 class="main__weeks__slot__outline__popover__title">{{ week.start | date:(\'date_format\' | translate) }} → {{ week.end | date:(\'date_format\' | translate) }}</h4><ul class="list-unstyled main__weeks__slot__outline__popover__body"><li ng-repeat="place in ::week.places | orderBy:\'-weekly_new_cases\'" ng-show="::popoverFilter(place)"><em class="pull-right">&nbsp;{{ place.weekly_new_cases }}</em><strong>{{ place.code | lowercase | translate }}</strong></li></ul></div></div></div></div></div>'),t.put("components/menu/menu.html",'<div ng-controller="MenuCtrl"><a ng-click="visibleMenu = !visibleMenu" ng-class="{\'menu-toggler--active\': visibleMenu, \'menu-toggler--disable\': isAnimating }" class="menu-toggler"><i class="fa fa-bars"></i></a><div ng-class="{\'menu--collapse\': !visibleMenu, \'menu--disable\': isAnimating}" class="menu"><h1 ng-bind-html="\'app_title\' | translate" class="menu__app-title"></h1><ul class="menu__links list-unstyled"><li><a ui-sref="about">{{ \'about\' | translate }}</a></li><li><a ng-click="share()">{{ \'share\' | translate }}</a></li><li><a ng-click="showLanguages = !showLanguages"><i class="caret menu__links__icon"></i>{{ \'language\' | translate }}</a></li></ul><ul ng-show="showLanguages" class="menu__languages list-unstyled"><li ng-repeat="lang in languages track by $index"><a ng-click="useLanguage(lang)">{{ lang + \'_display\' | translate }}</a></li></ul><ul class="menu__social list-inline text-center"><li><a href="{{ \'twitter_url\' | translate }}" target="_blank"><i class="fa fa-fw fa-twitter"></i><span class="sr-only">Twitter</span></a></li><li><a href="{{ \'facebook_url\' | translate }}" target="_blank"><i class="fa fa-fw fa-facebook"></i><span class="sr-only">Facebook</span></a></li><li><a href="{{ \'gplus_url\' | translate }}" target="_blank"><i class="fa fa-fw fa-google-plus"></i><span class="sr-only">Google+</span></a></li></ul><a tile="Médecins Sans Frontières" ui-sref="main({ skip: \'1\' })" class="menu__logo"></a><div class="menu__headline">{{ \'msf_headline\' | translate }}</div><a href="http://jplusplus.org" target="_blank" class="menu__credits"><img src="http://logo-js.herokuapp.com/jpp/white/4A3B3C/" height="20">&nbsp; {{ \'by_jpp\' | translate }}</a></div></div>'),t.put("components/share/share.html",'<div class="share"><div class="modal-body"><button type="button" ng-click="close()" class="close share__close"><span aria-hidden="true">&times;</span></button><div class="row"><div class="col-sm-6"><h4>{{ "share" | translate }}</h4><p>{{ "share_desc" | translate }}</p><ul ng-social-buttons="ng-social-buttons" class="pull-left"><li class="ng-social-facebook">Facebook</li><li class="ng-social-google-plus">Google</li></ul><ul ng-social-buttons="ng-social-buttons" data-title="\'tweet_text\' | translate" data-description="\'app_desc\' | translate" data-image="\'app_img\' | translate"><li class="ng-social-twitter">Twitter</li></ul></div><div class="col-sm-6"><h4>{{ "embed" | translate }}</h4><p>{{ "embed_desc" | translate }}</p><textarea readonly="readonly" rows="3" class="form-control">{{ getIframe() }}</textarea></div></div></div></div>'),t.put("app/main/popup/popup.html",'<div class="main__map__popup main__map__popup--{{ center.type | lowercase }}"><h4 class="main__map__popup__title"><i ng-show="center.type == \'CTE\'" class="fa fa-fw fa-dot-circle-o main__map__popup__title__icon"></i><i ng-show="center.type == \'support\'" class="fa fa-fw fa-circle main__map__popup__title__icon"></i>{{ center.display_name }}<div class="main__map__popup__title__today">{{ today | date:(\'date_format\' | translate) }}</div></h4><div ng-hide="center.type == \'support\'" class="main__map__popup__body"><p>{{ \'staff_count\' | translate }} <strong>{{ center.staff_count }}</strong><br>{{ \'weekly_new_admissions\' | translate }} <strong>{{ center.weekly_new_confirmed }}</strong></p></div></div>')}]);