# lookup

A command-line tool for translating English and Spanish words, managing a local vocabulary database, and automatically fetching and playing audio pronunciations. The project grew out of a simple habit: when you needed a word, you looked it up and saved it in a `.txt` file; over time those files became the local “database” the scripts search. If a word is missing, the tools can fall back to external translation (for example via the `trans` CLI).

## Key Features

- **Local Vocabulary Database**: Look up words and maintain your own personal English-Spanish dictionary stored purely as `.txt` files.
- **Audio Pronunciations**: Automatically downloads and plays audio pronunciations for English words. Uses an intelligent API fallback sequence (DictionaryAPI → Google Dictionary → Wiktionary → Google TTS) to ensure audio is always found, complete with clean download progress bars.
- **Interactive Editing**: When adding a new word, interactively correct the English and Spanish fields directly in the terminal before committing them to the database.
- **Automatic Git Backups**: The tool automatically creates commits in the background to version control your growing vocabulary without interrupting your workflow.

![](https://github.com/carlos-santiago-2017/DictEnEsScript/blob/master/1.gif)

## What `lookup.sh` does

`lookup.sh` is the **lookup / practice** script. It runs in a loop:

1. Prompts you to type a word (no command-line arguments; run it as documented below).
2. If the word exists in the **English** vocabulary files, it shows the translation and can play audio when available.
3. If not in English, it checks the **Spanish** side, normalizes the file content, and shows the English equivalent.
4. If the word is in neither list, it can use a Google Translate–backed flow (`search_word_using_google_script`) and then offer UI to add or refine entries.

Supporting logic (colors, audio, file layout, menus) lives in `directory_paths.sh` and the files it sources under `helper-functions/`, `trad-functions/`, and `add-functions/`.

### Execution Flowchart

```mermaid
flowchart TD
    Start([Start]) --> ArgumentsCheck{"Has Arguments?"}
    
    ArgumentsCheck -- Yes --> Error["Display Error & Exit"]
    ArgumentsCheck -- No --> LoopStart(("Main Loop"))
    
    LoopStart --> PrintTitle["Print Title"]
    PrintTitle --> ReadWord[/"Prompt User: Type a word"/]
    
    ReadWord --> IsEmpty{"Is word empty?"}
    IsEmpty -- Yes --> ProcessEmptyWord["Process Empty Word"]
    ProcessEmptyWord --> PlayLast["Play Audio of Last Found Word"]
    PlayLast --> LoopStart
    
    IsEmpty -- No --> CheckEnglish{"Is it a retrievable\nEnglish word?"}
    
    CheckEnglish -- Yes --> ProcessEnglishWord["Process English Word"]
    ProcessEnglishWord --> PlayAudioEN["Play English Audio"]
    PlayAudioEN --> DisplayTranslEN["Display English Translation"]
    DisplayTranslEN --> SetLastWordEN["Save as last found word"]
    SetLastWordEN --> LoopStart
    
    CheckEnglish -- No --> CheckSpanish{"Is it a retrievable\nSpanish word?"}
    
    CheckSpanish -- Yes --> ProcessSpanishWord["Process Spanish Word"]
    ProcessSpanishWord --> CleanSpanish["Clean Spanish File"]
    CleanSpanish --> DisplayTranslES["Display Spanish Translation"]
    DisplayTranslES --> PlayAudioES["Play Equivalent English Audio"]
    PlayAudioES --> SetLastWordES["Save as last found word"]
    SetLastWordES --> LoopStart
    
    CheckSpanish -- No --> ProcessUnknown["Process Unknown Word"]
    ProcessUnknown --> GoogleTranslate["Translate using Google script"]
    GoogleTranslate --> PlayAudioUnk["Play English Audio"]
    PlayAudioUnk --> OptionAdd["Display option to add new word"]
    OptionAdd --> DisplayMenu["Display Interactive Menu"]
    DisplayMenu --> LoopStart
```

## What `addWord.sh` does

`addWord.sh` is the **editor** for new or existing entries. It is meant to be run with no arguments. It:

1. Cleans stray empty vocabulary files (`delete_empty_files`).
2. In a loop, prints a header and asks for **one English word** (`print_header` → `read ENGLISH`).
3. If that English word already exists, it can show the file, let you add another meaning, open `vim` on the pair of files, or cancel.
4. If the word is new, it walks you through prompts (`read_inputs`) for Spanish text, extra notes, verb forms, examples, then creates or updates the English and Spanish files and related verb data.

So: **`lookup`** = search and translate; **`addWord`** = maintain the dictionary files.

### Execution Flowchart

```mermaid
flowchart TD
    Start([Start]) --> ArgumentsCheck{"Has Arguments?"}
    
    ArgumentsCheck -- Yes --> Error["Display Error & Exit"]
    ArgumentsCheck -- No --> DeleteEmpty["Delete Empty Files"]
    DeleteEmpty --> LoopStart(("Main Loop"))
    
    LoopStart --> PrintHeader[/"Print Header & Prompt User: Type an English word"/]
    
    PrintHeader --> CheckExisting{"Does English word exist?"}
    
    CheckExisting -- Yes --> HandleExisting["Handle Existing Word"]
    HandleExisting --> DisplayWord["Display current meanings"]
    DisplayWord --> PromptAddMeaning{"Add another meaning?\n[yes/no/edit]"}
    
    PromptAddMeaning -- yes --> HandleAddMeaning["Handle Add Meaning"]
    HandleAddMeaning --> ReadInputs["Read Spanish, Verb forms, Notes"]
    ReadInputs --> PrintInputs["Print Inputs"]
    PrintInputs --> ConfirmAdd{"Confirm?\n[yes/no]"}
    ConfirmAdd -- yes --> SaveExisting["Save Translations & Verbs\nClean Files"] --> LoopStart
    ConfirmAdd -- no --> CancelAdd["Cancel"] --> LoopStart
    
    PromptAddMeaning -- no --> LogTask["Log Task"] --> LoopStart
    PromptAddMeaning -- edit --> OpenVim["Open files in Vim"] --> LoopStart
    PromptAddMeaning -- other --> WrongKey1["Wrong Key Error"] --> LoopStart
    
    CheckExisting -- No --> IsEmpty{"Is word empty?"}
    IsEmpty -- Yes --> PrintEmpty["Print Empty Word Error"] --> LoopStart
    
    IsEmpty -- No --> HandleNew["Handle New Word"]
    HandleNew --> ReadInputsNew["Read Spanish, Verb forms, Notes"]
    ReadInputsNew --> PrintInputsNew["Print Inputs"]
    PrintInputsNew --> SelectConfirm{"Select option:\n[yes/no/quit]"}
    
    SelectConfirm -- yes --> SaveNew["Create Files\nSave Translations & Verbs"] --> LoopStart
    SelectConfirm -- no --> CancelNew["Cancel"] --> LoopStart
    SelectConfirm -- quit --> LoopStart
```

## Dependencies

The `install.sh` script will automatically attempt to install the following dependencies for you:

- **gawk** (installed via Homebrew)
- **sox** (audio tooling, installed via Homebrew)
- **`trans`** (command-line translator, downloaded directly)

## Installation

### Using `install.sh`

`install.sh` installs global `lookup` and `addWord` commands by creating symbolic links from `lookup.sh` and `addWord.sh` in the repository to `/usr/local/bin/lookup` and `/usr/local/bin/addWord`.

1. From a terminal, `cd` into the cloned repository (the directory that contains `install.sh`, `lookup.sh`, and `addWord.sh`).
2. Ensure the installer can run: `chmod +x install.sh` (once).
3. Run the installer:

```console
./install.sh
```

The script resolves the repository path automatically, makes both scripts executable, and runs `ln -sf` for each link. If your user cannot write to `/usr/local/bin`, the script uses `sudo` for those steps.

After a successful run, you can run `lookup` or `addWord` from any directory (as long as `/usr/local/bin` is on your `PATH`). No `TRAD3_PATH` environment variable is required.

## How to invoke the scripts

Run the symlinks created by `install.sh`:

```console
lookup
addWord
```

Do **not** pass arguments to these scripts; they are interactive only.

## How the Bash scripts are written

The codebase follows a small, consistent pattern:

1. **Shebang and strict sourcing**  
   Scripts start with `#!/usr/bin/env bash` and load shared paths and helpers with:

   ```bash
   . "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/directory_paths.sh"
   ```

   `directory_paths.sh` computes `REPO_DIR` from its own location, sets vocabulary directory variables from that base path, and dot-sources shared modules (`helper-functions/*.sh`, `trad-functions/*.sh`, `add-functions/*.sh`).

2. **Modular functions**  
   Behavior is split into **lowercase functions with underscores** (for example `process_english_word`, `handle_new_word`, `is_retrievable_english_word`). `lookup.sh` uses small processors for each case; `addWord.sh` uses `handle_*` helpers and a `main` that dispatches the loop.

3. **User-facing strings**  
   Fixed messages are often stored in **`readonly`** variables at the top of `lookup.sh` so colors and wording stay in one place.

4. **Interactive loops**  
   `lookup.sh` uses `while :; do` with `read word`; `addWord.sh` uses `while true` around `print_header` and branching on whether the English word already exists.

5. **No arguments**  
   Both entry scripts expect to be run with **no CLI arguments**; they check `$#` and tell you to invoke them by name only.

6. **Colors**  
   Terminal colors come from variables such as `${WHITE}`, `${GREEN}`, `${RED}` defined in `helper-functions/colors.sh`.

7. **Data layout**  
   Paths like `ENGLISH_DIRECTORY_PATH` and `SPANISH_DIRECTORY_PATH` keep file I/O out of the main loop logic where possible.

For full implementations, open `lookup.sh`, `addWord.sh`, and `directory_paths.sh` in the repository.
