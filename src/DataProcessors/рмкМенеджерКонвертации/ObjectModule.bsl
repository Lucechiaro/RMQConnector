#Область ПрограммныйИнтерфейс

//@skip-check module-accessibility-at-client
Функция ПолучитьДоступныеМетоды() Экспорт
	
	ИменаМетодов = Новый Массив;
	ИменаМетодов.Добавить("ИсходящиеСообщения_СформироватьСообщение_Номенклатура");
	ИменаМетодов.Добавить("ВходящиеСообщения_ПрочитатьНоменклатуру");
	ИменаМетодов.Добавить("ИсходящиеСообщения_СформироватьСообщениеНоменклатура_Простая");
	ИменаМетодов.Добавить("ВходящиеСообщения_ПрочитатьНоменклатуру_Простая");
		
	Возврат ИменаМетодов;
	
КонецФункции

//@skip-check module-accessibility-at-client
Процедура ВыполнитьМетод(ИмяМетода, Параметры) Экспорт
	
	Если ИмяМетода = "ИсходящиеСообщения_СформироватьСообщение_Номенклатура" Тогда
		ИсходящиеСообщения_СформироватьСообщение_Номенклатура(Параметры);
	ИначеЕсли ИмяМетода = "ВходящиеСообщения_ПрочитатьНоменклатуру" Тогда
		ВходящиеСообщения_ПрочитатьНоменклатуру(Параметры);
	ИначеЕсли ИмяМетода = "ИсходящиеСообщения_СформироватьСообщениеНоменклатура_Простая" Тогда
		ИсходящиеСообщения_СформироватьСообщениеНоменклатура_Простая(Параметры);
	ИначеЕсли ИмяМетода = "ВходящиеСообщения_ПрочитатьНоменклатуру_Простая" Тогда
		ВходящиеСообщения_ПрочитатьНоменклатуру_Простая(Параметры);	
	Иначе
		ВызватьИсключение СтрШаблон("Не найден метод конвертации %1", ИмяМетода);
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//@skip-check module-accessibility-at-client
Процедура ИсходящиеСообщения_СформироватьСообщение_Номенклатура(Параметры)
	
	ОбъектДляСериализации	= Параметры.ОбъектДляСериализации;
	ДанныеСообщения 		= Параметры.ДанныеСообщения;
	
	// задействуем платформенную сериализацию
	ДанныеСообщения.Вставить("Type", 	"SKU");
	ДанныеСообщения.Вставить("SerializationMetod", 	"1CXDTO");
	//ДанныеСообщения.Вставить("SerializationObjectType", "SKU");
	ДанныеСообщения.Вставить("Content", ОбъектДляСериализации);
	
КонецПроцедуры	

//@skip-check module-accessibility-at-client
Процедура ВходящиеСообщения_ПрочитатьНоменклатуру(КонтейнерСообщения)
	
	ПроверитьТипВходящегоСообщения(КонтейнерСообщения, "SKU");
	
	НоменклатураОбъект = КонтейнерСообщения.Content;
	УстановитьДополнительныеПараметрыЗаписиОбъета(НоменклатураОбъект);
	НоменклатураОбъект.Записать();
	
КонецПроцедуры

//@skip-check module-accessibility-at-client
Процедура ИсходящиеСообщения_СформироватьСообщениеНоменклатура_Простая(Параметры)
	
	ОбъектДляСериализации	= Параметры.ОбъектДляСериализации;
	ДанныеСообщения 		= Параметры.ДанныеСообщения;
	
	// задействуем платформенную сериализацию
	ДанныеСообщения.Вставить("Type", 	"SKU");
	ДанныеСообщения.Вставить("SerializationMetod", 	"Simple");
	//ДанныеСообщения.Вставить("SerializationObjectType", "SKU");
	
	СтруктураНоменклатуры = Новый Структура();
	СтруктураНоменклатуры.Вставить("UUID", XMLСтрока(ОбъектДляСериализации.Ссылка));
	СтруктураНоменклатуры.Вставить("Name", ОбъектДляСериализации.Наименование);
	СтруктураНоменклатуры.Вставить("PLU", 	ОбъектДляСериализации.Артикул);
	СтруктураНоменклатуры.Вставить("Description", ОбъектДляСериализации.Описание);
	
	ДанныеСообщения.Вставить("Content", СтруктураНоменклатуры);
	
КонецПроцедуры	

//@skip-check module-accessibility-at-client
Процедура ВходящиеСообщения_ПрочитатьНоменклатуру_Простая(КонтейнерСообщения)
	
	ПроверитьТипВходящегоСообщения(КонтейнерСообщения, "SKU");
	
	ДанныеНоменклатуры = КонтейнерСообщения.Content;
	Ссылка = СсылкаПоУникальномуИдентификатору("Справочники.Тест_Номенклатура", ДанныеНоменклатуры.UUID);
	
	Если СсылкаСуществует(Ссылка) Тогда
		НоменклатураОбъект = Ссылка.ПолучитьОбъект();
	Иначе
		НоменклатураОбъект = Справочники.Тест_Номенклатура.СоздатьЭлемент();
		НоменклатураОбъект.УстановитьСсылкуНового(Ссылка);	
	КонецЕсли;	
	
	НоменклатураОбъект.Артикул 		= ДанныеНоменклатуры.PLU;
	НоменклатураОбъект.Наименование = ДанныеНоменклатуры.Name;
	НоменклатураОбъект.Описание 	= ДанныеНоменклатуры.Description;
	
	УстановитьДополнительныеПараметрыЗаписиОбъета(НоменклатураОбъект);
	НоменклатураОбъект.Записать();
	
КонецПроцедуры

Функция СсылкаПоУникальномуИдентификатору(ИмяМетаданных, УИДСтрокой)
	
	Перем МенеджерОбъекта;
	
	УстановитьПривилегированныйРежим(Истина);
	Выполнить("МенеджерОбъекта = " + ИмяМетаданных);
	УИД = Новый УникальныйИдентификатор(УИДСтрокой);
		
	Возврат МенеджерОбъекта.ПолучитьСсылку(УИД);
	
КонецФункции

// TODO вынести в переопределяемый модуль
Функция СсылкаСуществует(Ссылка)
	
	ПолноеИмяМетаданных = Ссылка.Метаданные().ПолноеИмя();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	1
	|ИЗ
	|	" + ПолноеИмяМетаданных + " КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции	

//@skip-check module-accessibility-at-client
Процедура ПроверитьТипВходящегоСообщения(КонтейнерСообщения, ИмяТипа)
	
	ТипКорректен = КонтейнерСообщения.Свойство("Type") И СтрСравнить(КонтейнерСообщения.Type, ИмяТипа) = 0;
	
	Если Не ТипКорректен Тогда
		ВызватьИсключение СтрШаблон("Сообщение не содержит ожидаемый тип ""%1""", ИмяТипа);
	КонецЕсли;	
	
КонецПроцедуры	

//@skip-check module-accessibility-at-client
Процедура УстановитьДополнительныеПараметрыЗаписиОбъета(ЗаписываемыйОбъект)
	
	ЗаписываемыйОбъект.ОбменДанными.Загрузка = Истина;
		
КонецПроцедуры	

#КонецОбласти


	