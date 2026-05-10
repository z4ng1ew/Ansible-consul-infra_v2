#!/bin/bash

# Скрипт для сохранения содержимого всех текстовых файлов проекта в один файл.
# Использование: ./dump_all_files.sh [выходной_файл]
# По умолчанию выходной файл: project_dump.txt

OUTPUT_FILE="${1:-project_dump.txt}"

# Очищаем или создаём выходной файл
> "$OUTPUT_FILE"

echo "Сканирование файлов проекта (исключая .git и бинарные файлы)..."

# Находим все файлы, исключая директорию .git и бинарные файлы
find . -type f ! -path "./.git/*" | while read -r file; do
    # Проверяем, является ли файл текстовым (не бинарным)
    if grep -Iq . "$file" 2>/dev/null; then
        # Записываем заголовок с путём к файлу
        echo "================== ФАЙЛ: $file ==================" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        # Добавляем содержимое файла
        cat "$file" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "Обработан: $file"
    else
        echo "Пропущен бинарный файл: $file"
    fi
done

echo "Готово! Результат сохранён в $OUTPUT_FILE"
