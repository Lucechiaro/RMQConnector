#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Объект.МенеджерКонвертации.Пустая() Тогда
		ЗаполнитьОбработчики(ЭтотОбъект);
	КонецЕсли;
		
	ДопустимыеМетаданные = рмкОбщегоНазначения.МетаданныеДоступныеДляРепликации();
	Элементы.ПолноеИмяМетаданных.СписокВыбора.ЗагрузитьЗначения(ДопустимыеМетаданные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МенеджерКонвертацииПриИзменении(Элемент)
	
	Объект.ИмяМетодаКонвертации = "";
	ЗаполнитьОбработчики(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьМассивОбработчиков(СпособСериализации) 
		
	Попытка
		
		МенеджерКонвертации = рмкОбработкаСообщений.ПолучитьМенеджерКонвертации(Неопределено, СпособСериализации);
		МассивОбработчиков = МенеджерКонвертации.ПолучитьДоступныеМетоды("Исходящее")
		
	Исключение
		
		МассивОбработчиков = Новый Массив;
		ОписаниеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		рмкОбщегоНазначенияПереопределяемый.СообщитьПользователю(ОписаниеОшибки);
				
	КонецПопытки;
	
	Возврат МассивОбработчиков;
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОбработчики(Форма)
	
	Форма.Элементы.ИмяМетодаКонвертации.СписокВыбора.Очистить();
	
	Обработчики = ПолучитьМассивОбработчиков(Форма.Объект.МенеджерКонвертации);
	
	Для Каждого ИмяОбработчика Из Обработчики Цикл
		Форма.Элементы.ИмяМетодаКонвертации.СписокВыбора.Добавить(ИмяОбработчика);
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти	


