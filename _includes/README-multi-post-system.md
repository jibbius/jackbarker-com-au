# Multi-Post Series System

This site uses a generic multi-post series system that automatically detects and displays parent-child post relationships. Any blog series can use this system.

## How to Create a Multi-Part Series

### 1. Create the Parent Post

The parent post acts as the introduction/overview for the series:

```yaml
---
layout: post
title: "How to build a Photo Booth"
permalink: /photo-booth/
# ... other front matter
---

{% include multi-post-summary.html %}

Your introduction content here...
```

**Key points:**
- **No special front matter needed** - the system auto-detects parent posts
- Use a permalink that other posts can reference
- Include `{% include multi-post-summary.html %}` where you want the series navigation

### 2. Create Child Posts

Each part of the series references the parent:

```yaml
---
layout: post
title: "Photo Booth (Part 1): Requirements"
parent_post: "/photo-booth/"    # Must match parent's permalink
series_order: 1                # Optional: for custom ordering
permalink: /photo-booth/1
# ... other front matter
---

{% include multi-post-summary.html %}

Your part content here...
```

**Key points:**
- `parent_post` must exactly match the parent's permalink
- `series_order` is optional - will sort by date if not provided
- Include `{% include multi-post-summary.html %}` for navigation

## Features

### Automatic Detection
- **Parent posts**: Detected when other posts reference them via `parent_post`
- **Child posts**: Detected by having a `parent_post` field
- **Current post highlighting**: Shows "(this post)" for the current page

### Smart Ordering
1. Parent post always appears first
2. Child posts sorted by `series_order` if provided
3. Falls back to date sorting if no `series_order`

### Clean URLs
- Uses `site.baseurl` for environment-agnostic URLs
- Works in both development and production

### Title Extraction
- For parent posts: Uses full title
- For child posts: Extracts text after ": " (e.g., "Photo Booth (Part 1): Requirements" → "Requirements")

## Example Output

```
Multi-part Series

This article is part of the How to build a Photo Booth series:

• How to build a Photo Booth
• Part 1: Requirements (this post)
• Part 2: Getting started with Pi and PiCamera  
• Part 3: Building the Booth
• Part 4: Wiring up the circuit
• Part 5: The code
• Part 6: Fine-tuning
• Part 7: Photo day!
• Part 8: Post-production
```

## Usage

Simply add `{% include multi-post-summary.html %}` to any post that's part of a series. The system will:

1. Determine if the current post is part of a series
2. Find all related posts (parent + children)  
3. Generate the complete navigation list
4. Highlight the current post

**No parameters needed** - everything is auto-detected from front matter.