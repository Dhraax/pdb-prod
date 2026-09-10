# Puerta de Baldur Forum Post Format

Use this reference when the user asks for a forum post or asks to convert text
for publication on the Puerta de Baldur forum.

## Main text wrapper

Wrap the post body in the following tags:

```text
[JUSTIFY][COLOR=rgb(0, 0, 0)][FONT=Verdana]
Post content
[/FONT][/COLOR][/JUSTIFY]
```

Keep the opening tags together. Close them in reverse order. Use real Spanish
characters rather than HTML entities.

## Supported inline formatting

```text
[B]Bold text[/B]
[U]Underlined text[/U]
[OFFTOPIC]Off-topic text[/OFFTOPIC]
```

Use BBCode instead of Markdown headings, blockquotes, bold, or underline in a
forum-ready document.

## Quote blocks

Close the current main wrapper before a quote. Give the quote its own complete
wrapper, then reopen the main wrapper after it:

```text
[/FONT][/COLOR][/JUSTIFY]
[QUOTE]
[JUSTIFY][COLOR=rgb(0, 0, 0)][FONT=Verdana]Quoted text[/FONT][/COLOR][/JUSTIFY]
[/QUOTE]
[JUSTIFY][COLOR=rgb(0, 0, 0)][FONT=Verdana]
```

Do not leave empty wrappers at the end of a post. Existing character sheets may
use additional forum tags such as `[LIST]`, `[IMG]`, `[URL]`, `[SIZE]`, or tabs;
preserve them when editing an existing post, but do not introduce them unless
the requested layout needs them.
