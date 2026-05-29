# Skill: Generating Metro Line Collector Stamps

This skill provides a standardized workflow and prompt for generating "Collector Stamps" for Guangzhou Metro lines. These stamps are minimalist, blue-ink style images of the trains, used to add a "collectible" feel to the line documentation.

## 🎯 Objective
Create a consistent, high-quality, blue-ink rubber stamp image for any metro line and integrate it into the markdown content.

## 🛠️ Step-by-Step Workflow

### 1. Identify the Train
Refer to the "Photos" section or the "Fun Facts" in the line's markdown file to identify the train model (e.g., A1, B1, L-type).

### 2. Generate the Image
To ensure the stamp is authentic to the specific train model, you **must** extract the image URLs from the `## Photos` section of the line's markdown file and use them as visual references.

Use an AI image generator (like Gemini Flash Image) that supports image-to-image or image-referencing. Provide the reference URL(s) along with this specific prompt:

> **Prompt Template:**
> A square image featuring a minimalist blue ink stamp of the train shown in the reference image. The design is a single-tone blue color on a clean white paper-textured background, mimicking the look of a traditional rubber stamp. The train's appearance (shape, windows, front design) should strictly follow the reference photo. The style should be clean and graphic from a 3/4 front perspective with a slight weathered texture. The overall composition is centered and square. Include the Chinese characters "[SPECIFIC LINE NAME IN CHINESE]" in a bold traditional stamp font, the train model name (e.g., "[TRAIN MODEL]型列车"), and the English text "GUANGZHOU METRO" at the bottom.

**How to adapt the text:**
Replace `[SPECIFIC LINE NAME IN CHINESE]` based on the line type:
- **Metro Lines**: "广州地铁[X]号线" (e.g., 广州地铁1号线)
- **APM Line**: "广州地铁APM线"
- **Trams**: "[LOCATION]有轨电车" (e.g., 海珠有轨电车, 黄埔有轨电车1号线)
- **Guangfo Line**: "广佛线"
- **Foshan Metro**: "佛山地铁[X]号线"

Replace `[TRAIN MODEL]` with the train model from the line details (e.g., "A1", "B1", "L"). If unknown, omit the train model line.

**Key Constraints:**
- **Color**: Single-tone blue ink only.
- **Background**: Clean white with a subtle paper texture.
- **Shape**: Square (1:1).
- **Style**: Minimalist, weathered rubber stamp effect.

### 3. Save the File
- **Target Path**: `data/generated_images/line-[X]-stamp.png`
- **Naming Convention**: Use the line number or identifier (e.g., `line-1`, `apm`, `foshan-2`).

### 4. Update Markdown Content
Add the following sections before the `## Sources` section in the respective files. **Ensure the text matches the specific line name (e.g., Line 1, APM Line, Haizhu Tram).**

#### English (`data/en/line-[X].md`)
```markdown
## Collector's Stamp

![[LINE NAME] Stamp](../generated_images/line-[X]-stamp.png)

- **Description**: A minimalist blue ink stamp featuring the classic train of Guangzhou Metro [LINE NAME].
```

#### Chinese (`data/zh/line-[X].md`)
```markdown
## 收藏家印章

![[LINE NAME]印章](../generated_images/line-[X]-stamp.png)

- **说明**：一款简约的蓝色墨水印章，展示了广州地铁[LINE NAME]的经典列车。
```

> [!TIP]
> Just like the prompt, adapt "[LINE NAME]" to fit the context (e.g., "Line 1", "APM Line", "Haizhu Tram", "广佛线").

## ✅ Quality Checklist
1. [ ] Image is square and centered.
2. [ ] Image uses only blue ink on a white background.
3. [ ] File is saved in `data/generated_images/`.
4. [ ] Both EN and ZH markdown files are updated.
5. [ ] Paths in markdown are relative (e.g., `../generated_images/...`).
