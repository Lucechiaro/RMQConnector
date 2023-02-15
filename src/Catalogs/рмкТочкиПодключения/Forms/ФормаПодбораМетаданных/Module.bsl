#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ВыбранныеМетаданные;
	
	ЗаполнитьДоступныеМетаданные();
	Параметры.Свойство("ВыбранныеМетаданные", ВыбранныеМетаданные);
	
	Если ТипЗнч(ВыбранныеМетаданные) = Тип("Массив") Тогда
		ОтметитьВыбранныеМетаданные(ЭтотОбъект, ВыбранныеМетаданные);
	КонецЕсли;	
	
	РежимОтображения = "ТолькоВыбранные";
	УстановитьФильтрСтрок(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОтображенияПриИзменении(Элемент)
	
	УстановитьФильтрСтрок(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы
	
&НаКлиенте
Процедура Ок(Команда)
	
	Закрыть(МассивВыбранныхМетаданных(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	УстановитьОтметкиМетаданных(ЭтотОбъект, Истина);
	УстановитьФильтрСтрок(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	УстановитьОтметкиМетаданных(ЭтотОбъект, Ложь);
	УстановитьФильтрСтрок(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	
	МассивМетаданных = МассивВыбранныхМетаданных(ЭтотОбъект);
	СтрокаJSON = МассивМетаданныхСтрокойJSON(МассивМетаданных);
		
	ДополнительныеСвойства = Новый Структура("СтрокаJSON,РежимДиалога", СтрокаJSON, РежимДиалогаВыбораФайла.Сохранение);
	Диалог = Новый ДиалогВыбораФайла(ДополнительныеСвойства.РежимДиалога);
	Диалог.Расширение = "json";
	Диалог.Фильтр = "Файл JSON (*.json)|*.json";
	ООВыборФайла = Новый ОписаниеОповещения("ООВыборФайлаЗавершение", ЭтотОбъект, ДополнительныеСвойства);
	Диалог.Показать(ООВыборФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьИзФайла(Команда)
	
	ДополнительныеСвойства = Новый Структура("РежимДиалога", РежимДиалогаВыбораФайла.Открытие);
	Диалог = Новый ДиалогВыбораФайла(ДополнительныеСвойства.РежимДиалога);
	Диалог.Расширение = "json";
	Диалог.Фильтр = "Файл JSON (*.json)|*.json";
	ООВыборФайла = Новый ОписаниеОповещения("ООВыборФайлаЗавершение", ЭтотОбъект, ДополнительныеСвойства);
	Диалог.Показать(ООВыборФайла);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОтметитьВыбранныеМетаданные(Форма, ВыбранныеМетаданные)
	
	ОтборМетаданные = Новый Структура("ПолноеИмя");
	
	Для Каждого ИмяМетаданных Из ВыбранныеМетаданные Цикл
		
		ОтборМетаданные.ПолноеИмя = ИмяМетаданных;
		НайденныеСтроки = Форма.ТаблицаМетаданных.НайтиСтроки(ОтборМетаданные);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].Выбран = Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеМетаданные()
	
	ДоступныеМетаданные = рмкОбщегоНазначенияПовтИсп.МетаданныеДоступныеДляРепликации();
	
	Для Каждого ИмяМетаданных Из ДоступныеМетаданные Цикл
		
		НоваяСтрока = ТаблицаМетаданных.Добавить();
		НоваяСтрока.ПолноеИмя = ИмяМетаданных;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивВыбранныхМетаданных(Форма)
	
	МассивВыбранных = Новый Массив;
	
	Для Каждого СтрокаМетаданных Из Форма.ТаблицаМетаданных Цикл
		
		Если СтрокаМетаданных.Выбран Тогда
			МассивВыбранных.Добавить(СтрокаМетаданных.ПолноеИмя);
		КонецЕсли;	
		
	КонецЦикла;
		
	Возврат МассивВыбранных;	
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФильтрСтрок(Форма)
	
	Если Форма.РежимОтображения = "ТолькоВыбранные" Тогда
		Форма.Элементы.ТаблицаМетаданных.ОтборСтрок = Новый ФиксированнаяСтруктура("Выбран", Истина);
	Иначе
		Форма.Элементы.ТаблицаМетаданных.ОтборСтрок = Неопределено;	
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтметкиМетаданных(Форма, ЗначениеОтметки)
	
	Для Каждого СтрокаМетаданных Из Форма.ТаблицаМетаданных Цикл
		СтрокаМетаданных.Выбран = ЗначениеОтметки;
	КонецЦикла;	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МассивМетаданныхСтрокойJSON(Массив)
	
	СтруктураДанных = Новый Структура("МассивМетаданныхТочкиПодключения", Массив);
	
	Возврат рмкОбщегоНазначения.СериализоватьОбъект(СтруктураДанных);
	
КонецФункции	

&НаСервереБезКонтекста
Функция МассивМетаданныхИзСтрокиJSON(СтрокаJSON)
	
	Возврат рмкОбщегоНазначения.ДесериализоватьОбъект(СтрокаJSON)["МассивМетаданныхТочкиПодключения"];
	
КонецФункции

&НаКлиенте
Процедура ООВыборФайлаЗавершение(ИменаФайлов, ДополнительныеСвойства) Экспорт
	
	Если ДополнительныеСвойства.РежимДиалога = РежимДиалогаВыбораФайла.Сохранение Тогда
	
		Если ИменаФайлов <> Неопределено И ИменаФайлов.Количество() > 0 Тогда
			ЗаписатьСтрокуВФайл(ИменаФайлов[0], ДополнительныеСвойства.СтрокаJSON);
		КонецЕсли;
	
	Иначе
		
		Если ИменаФайлов <> Неопределено И ИменаФайлов.Количество() > 0 Тогда
			ПрочитатьСписокМетаданныхИзФайла(ИменаФайлов[0]);
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьСтрокуВФайл(ИмяФайла, Строка)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(Строка);
	ОповещениеЗаписиФайлаМетаданных = Новый ОписаниеОповещения("ОкончаниеЗаписиФайлаМетаданных", ЭтотОбъект);
	ТекстовыйДокумент.НачатьЗапись(ОповещениеЗаписиФайлаМетаданных, ИмяФайла);
	
КонецПроцедуры	

&НаКлиенте
Процедура ОкончаниеЗаписиФайлаМетаданных(Результат, ДополнительныеСвойства) Экспорт
	
	Если Результат <> Истина Тогда
		рмкОбщегоНазначенияКлиентПереопределяемый.СообщитьПользователю("Не удалось выгрузить метаданные!");
	КонецЕсли;			
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьСписокМетаданныхИзФайла(ИмяФайла)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ДополнительныеПараметры = Новый Структура("ТекстовыйДокумент", ТекстовыйДокумент);
	ОповещениеЧтенияФайлаМетаданных = Новый ОписаниеОповещения("ОкончаниеЧтенияФайлаМетаданных", ЭтотОбъект, ДополнительныеПараметры);
	ТекстовыйДокумент.НачатьЧтение(ОповещениеЧтенияФайлаМетаданных, ИмяФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеЧтенияФайлаМетаданных(ДополнительныеСвойства) Экспорт
	
	Попытка
		МассивМетаданных = МассивМетаданныхИзСтрокиJSON(ДополнительныеСвойства.ТекстовыйДокумент.ПолучитьТекст());
		ОтметитьВыбранныеМетаданные(ЭтотОбъект, МассивМетаданных);
		УстановитьФильтрСтрок(ЭтотОбъект);

	Исключение

		рмкОбщегоНазначенияКлиентПереопределяемый.СообщитьПользователю("Не удалось прочитать файл");
		рмкОбщегоНазначенияКлиентПереопределяемый.СообщитьПользователю(ОбработкаОшибок.ПодробноеПредставлениеОшибки(
			ИнформацияОбОшибке()));

	КонецПопытки;

КонецПроцедуры

#КонецОбласти
