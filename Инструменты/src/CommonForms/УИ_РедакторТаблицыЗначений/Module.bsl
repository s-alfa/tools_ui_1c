&НаКлиенте
Процедура СтруктураТаблицыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ОбработатьИзменениеИмениКолонки(НоваяСтрока, ОтменаРедактирования, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеИмениКолонки(НоваяСтрока, ОтменаРедактирования, Отказ)

	стрИмяКолонки = Элементы.СтруктураТаблицы.ТекущиеДанные.Имя;

	фИмяКорректно = Ложь;
	Попытка
		ст = Новый Структура(стрИмяКолонки);
		фИмяКорректно = ЗначениеЗаполнено(стрИмяКолонки);
	Исключение
	КонецПопытки;

	Если Не фИмяКорректно Тогда
		ПоказатьПредупреждение( ,
			"Неверное имя колонки! Имя должно состоять из одного слова, начинаться с буквы и не содержать специальных символов кроме ""_"".",
			, Заголовок);
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	маСтрокиИмени = СтруктураТаблицы.НайтиСтроки(Новый Структура("Имя", стрИмяКолонки));
	Если маСтрокиИмени.Количество() > 1 Тогда
		ПоказатьПредупреждение( , "Колонка с таким именем уже есть! Введите другое имя.", , Заголовок);
		Отказ = Истина;
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтруктураТаблицыТипЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанные=Элементы.СтруктураТаблицы.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекСтрока=Элементы.СтруктураТаблицы.ТекущаяСтрока;

	УИ_ОбщегоНазначенияКлиент.РедактироватьТип(ТекДанные.ТипЗначения, 1, СтандартнаяОбработка, ЭтотОбъект,
		Новый ОписаниеОповещения("СтруктураТаблицыТипЗначенияНачалоВыбораЗавершение", ЭтотОбъект,
		Новый Структура("ТекСтрока", ТекСтрока)));
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьМодификаторыТипа(ТипЗначения)

	маКвалификаторы = Новый Массив;

	Если ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		стрКвалификаторыСтроки = "Длина " + ТипЗначения.КвалификаторыСтроки.Длина;
		маКвалификаторы.Добавить(Новый Структура("Тип, Квалификаторы", "Строка", стрКвалификаторыСтроки));
	КонецЕсли;

	Если ТипЗначения.СодержитТип(Тип("Дата")) Тогда
		стрКвалификаторыДаты = ТипЗначения.КвалификаторыДаты.ЧастиДаты;
		маКвалификаторы.Добавить(Новый Структура("Тип, Квалификаторы", "Дата", стрКвалификаторыДаты));
	КонецЕсли;

	Если ТипЗначения.СодержитТип(Тип("Число")) Тогда
		стрКвалификаторыДаты = "Знак " + ТипЗначения.КвалификаторыЧисла.ДопустимыйЗнак + " "
			+ ТипЗначения.КвалификаторыЧисла.Разрядность + "." + ТипЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти;
		маКвалификаторы.Добавить(Новый Структура("Тип, Квалификаторы", "Число", стрКвалификаторыДаты));
	КонецЕсли;

	фНуженЗаголовок = маКвалификаторы.Количество() > 1;

	стрКвалификаторы = "";
	Для Каждого стКвалификаторы Из маКвалификаторы Цикл
		стрКвалификаторы = ?(фНуженЗаголовок, стКвалификаторы.Тип + ": ", "") + стКвалификаторы.Квалификаторы + "; ";
	КонецЦикла;

	Возврат стрКвалификаторы;

КонецФункции

&НаКлиенте
Процедура СтруктураТаблицыТипЗначенияНачалоВыбораЗавершение(Результат, ДополнительныеПараметры)
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекДанные=СтруктураТаблицы.НайтиПоИдентификатору(ДополнительныеПараметры.ТекСтрока);
	ТекДанные.ТипЗначения=Результат;
	ТекДанные.Квалификаторы=ПолучитьМодификаторыТипа(ТекДанные.ТипЗначения);
КонецПроцедуры