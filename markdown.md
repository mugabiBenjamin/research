# Markdown Syntax

- [Headings](#headings)
- [Heading Alternate Syntax](#heading-alternate-syntax)
- [Text formattings](#text-formattings)
- [Unordered lists](#unordered-lists)
- [Ordered lists](#ordered-lists)
- [Links](#links)
- [Image](#image)
- [Image with link](#image-with-link)
- [Inline code](#inline-code)
- [Code blocks](#code-blocks)
- [Syntax highlighting](#syntax-highlighting)
- [Tables](#tables)
- [Task List](#task-list)
- [Footnotes](#footnotes)
- [Collapsible section](#collapsible-section)
- [Escaping characters](#escaping-characters)
- [Horizontal rules](#horizontal-rules)

## Headings

```markdown
# Heading level 1
## Heading level 2
### Heading level 3
#### Heading level 4
##### Heading level 5
###### Heading level 6
```

## Heading Alternate Syntax

```markdown
# Heading level 1
## Heading level 2
```

## Text formattings

```markdown
**Bold text** or **Bold text**

_Italic text_ or _Italic text_

~~Strikethrough text~~

**_Bold and Italic text_** or **_Bold and Italic text_** or **_Bold and Italic text_** or **_Bold and Italic text_**

> for blockquotes
```

## Unordered lists

```markdown
- First item
- Second item
- Third item

* First item
* Second item
* Third item

- First item
- Second item
- Third item
```

## Ordered lists

```markdown
1. First item
2. Second item
3. Third item
```

## Links

```markdown
<https://jsmasterypro.com>

[Visit Google](https://google.com)

[JSM PRO](https://jsmasterypro.com "Blog") <!-- When you hover over the link, there's a tooltip -->

[Jump to Installation Section](#installation)
```

## Image

```markdown
![GitHub Logo](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png?raw=true)
```

## Image with link

```markdown
[![Landscape Image](landscape.jpg)](https://images.pexels.com/photos/17863401/pexels-photo-17863401/free-photo-of-a-road-is-in-the-middle-of-a-snowy-mountain-range.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1)
```

## Inline code

```markdown
Use single backticks for inline code.
Run the `npm install` command to install dependencies.
```

## Code blocks

Use single backticks (```) for code blocks.

```bash
# This is a bash command and a comment specifically
npm install
```

## Syntax highlighting

```javascript
function greet(name) {
  alert(`Hello ${name}`);
}
```

## Tables

```markdown
| Column 1 | Column 2 | Column 3 |
| -------- | :------: | -------: |
| Row 1    |  Data 1  |   Data 2 |
| Row 2    |  Data 3  |   Data 4 |
```

## Task List

```markdown
- [x] Completed task
- [ ] Incomplete task
```

## Footnotes

```markdown
Here is a statement with a footnote.[^1]

[^1]: This is the footnote text.
```

## Collapsible section

```markdown
<details>
<summary>Click to expand</summary>
Hidden content goes here.
</details>
```

## Escaping characters

```markdown
<!-- Won't italicize -->

\*This will not italicize.\*

<!--Won't create a header -->

\# This will not create a header.
```

## Horizontal rules

```markdown
Javascript Mastery

---

Javascript Mastery

---
```

[Back to top](#markdown-syntax)
