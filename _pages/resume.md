---
layout: default
title: Resume
permalink: /resume/
---

## Qualifications

<div class="qualifications-grid">
{% assign sorted_qualifications = site.career_qualifications | sort: 'completion_date' | reverse %}
{% for qualification in sorted_qualifications %}
  <div class="qualification-card">
    <div class="qualification-header">
      <div class="qualification-title-info">
        <h4><a href="{{ qualification.url }}">{{ qualification.title }}</a></h4>
        <div class="institution">{{ qualification.institution }}</div>
      </div>
      <div class="completion-year">({{ qualification.completion_date }})</div>
    </div>
    {% if qualification.content and qualification.content != '' %}
    <div class="qualification-description">
      {{ qualification.content }}
    </div>
    {% endif %}
  </div>
{% endfor %}
</div>

## Employment History

<div class="career-roles">
{% assign sorted_roles = site.career_roles | sort: 'end_date' | reverse %}
{% for role in sorted_roles %}
  <div class="role-card">
    <div class="role-header">
      <h3>{{ role.title }}</h3>
      <div class="company">{{ role.company }}</div>
      <div class="duration">{{ role.start_date }} - {{ role.end_date }}</div>
    </div>
    <div class="role-description">
      {{ role.content }}
    </div>
    
    {% assign role_projects = site.career_projects | where: 'role_id', role.slug %}
    {% if role_projects.size > 0 %}
    <div class="role-projects">
      <h4>Key Projects:</h4>
      {% for project in role_projects %}
        <div class="project-summary">
          <strong>{{ project.title }}</strong> ({{ project.duration }})
          <p>{{ project.excerpt }}</p>
        </div>
      {% endfor %}
    </div>
    {% endif %}
  </div>
{% endfor %}
</div>

## Technical Skills

<div class="skills-grid">
{% assign sorted_skills = site.career_skills | sort: 'order' %}
{% for skill in sorted_skills %}
  <div class="skill-category">
    <h4><a href="{{ skill.url }}">{{ skill.title }}</a></h4>
    {% if skill.skills and skill.skills.size > 0 %}
    <ul>
      {% for skill_item in skill.skills %}
        <li>{{ skill_item }}</li>
      {% endfor %}
    </ul>
    {% endif %}
  </div>
{% endfor %}
</div>

## Personal Accomplishments

- **2017 GovHack Hackathon (Ballarat)** - Winner: Commerce Ballarat Demographics, Honourable mention: Best Use of Census Data for "CityZen" project
- **2017 Raspberry Pi Photo Booth** - Open-source Python application featured in The MagPi #60 and DIYODE Magazine #01
- **2012-2015 Technical Co-founder at WhereTheTruck.at** - Full-stack development of food truck location platform, successful crowdfunding campaign and business sale

<style>
/* MODERN TECHNICAL RESUME DESIGN */
/* Clean, scannable, tech industry standard */

:root {
  /* Modern tech resume typography - larger, more readable */
  --tech-heading-xl: 2.5rem;     /* Page title */
  --tech-heading-lg: 2rem;       /* Section headers */  
  --tech-heading-md: 1.4rem;     /* Job titles */
  --tech-text-lg: 1.1rem;        /* Body text */
  --tech-text-base: 1rem;        /* Standard text */
  --tech-text-sm: 0.95rem;       /* Meta info */
  
  /* Professional color palette */
  --tech-navy: #1a365d;          /* Headers */
  --tech-blue: #2563eb;          /* Accents */
  --tech-blue-light: #60a5fa;    /* Subtle accents */
  --tech-gray-dark: #374151;     /* Body text */
  --tech-gray-med: #6b7280;      /* Meta text */
  --tech-gray-light: #f3f4f6;    /* Backgrounds */
  --tech-border: #e5e7eb;        /* Borders */
  
  /* Spacing system */
  --tech-space-xs: 0.5rem;
  --tech-space-sm: 0.75rem;
  --tech-space-md: 1rem;
  --tech-space-lg: 1.5rem;
  --tech-space-xl: 2rem;
  
}

/* TECH RESUME LAYOUT */
/* Modern single-column layout with generous whitespace */
.page-resume .post-content,
body.page-resume .post-content {
  max-width: 850px !important;
  margin: 0 auto !important;
  padding: var(--tech-space-xl) var(--tech-space-lg) !important;
  line-height: 1.6 !important;
}

/* TYPOGRAPHY - Modern tech resume hierarchy */
.page-resume .post-content h2,
body.page-resume .post-content h2 {
  font-size: var(--tech-heading-lg) !important;
  font-weight: 700 !important;
  color: var(--tech-navy) !important;
  margin-top: var(--tech-space-xl) !important;
  margin-bottom: var(--tech-space-lg) !important;
  padding-bottom: var(--tech-space-sm) !important;
  border-bottom: 2px solid var(--tech-blue) !important;
  text-transform: uppercase !important;
  letter-spacing: 1px !important;
}

/* First section - no top margin */
.page-resume .post-content h2:first-of-type,
body.page-resume .post-content h2:first-of-type {
  margin-top: 0 !important;
}

/* Job titles and qualification names */
.page-resume .post-content h3,
body.page-resume .post-content h3 {
  font-size: var(--tech-heading-md) !important;
  font-weight: 600 !important;
  color: var(--tech-navy) !important;
  margin: var(--tech-space-lg) 0 var(--tech-space-sm) 0 !important;
  line-height: 1.3 !important;
}

/* Subsection headers */
.page-resume .post-content h4,
body.page-resume .post-content h4 {
  font-size: var(--tech-text-lg) !important;
  font-weight: 600 !important;
  color: var(--tech-gray-dark) !important;
  margin: var(--tech-space-md) 0 var(--tech-space-sm) 0 !important;
}

/* Body text - larger and more readable */
.page-resume .post-content p,
body.page-resume .post-content p,
.page-resume .post-content li,
body.page-resume .post-content li {
  font-size: var(--tech-text-lg) !important;
  color: var(--tech-gray-dark) !important;
  line-height: 1.6 !important;
  margin-bottom: var(--tech-space-md) !important;
}

/* QUALIFICATIONS - Clean list format */
.qualifications-grid {
  margin: var(--tech-space-lg) 0;
}

.qualification-card {
  border-left: 2px solid var(--tech-blue-light);
  padding: var(--tech-space-lg);
  margin-bottom: var(--tech-space-lg);
  background: var(--tech-gray-light);
  border-radius: 0 6px 6px 0;
}

.qualification-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  flex-wrap: wrap;
  gap: var(--tech-space-md);
  margin-bottom: var(--tech-space-sm);
}

.qualification-title-info {
  flex: 1;
}

.qualification-header h4 {
  margin: 0 !important;
  font-size: var(--tech-text-lg) !important;
  font-weight: 600 !important;
  color: var(--tech-navy) !important;
}

.qualification-header h4 a {
  color: var(--tech-navy);
  text-decoration: none;
}

.qualification-header h4 a:hover {
  color: var(--tech-blue);
  text-decoration: underline;
}

.institution {
  font-weight: 500;
  color: var(--tech-gray-med);
  font-size: var(--tech-text-base);
  margin: var(--tech-space-xs) 0 0 0;
}

.completion-year {
  color: var(--tech-gray-med);
  font-weight: 500;
  font-size: var(--tech-text-sm);
  white-space: nowrap;
}

.qualification-description {
  margin-top: var(--tech-space-sm);
  font-size: var(--tech-text-base);
  color: var(--tech-gray-dark);
  line-height: 1.5;
}

/* EMPLOYMENT HISTORY - Timeline style */
.career-roles {
  margin: var(--tech-space-lg) 0;
}

.role-card {
  margin-bottom: var(--tech-space-xl);
  padding: var(--tech-space-lg);
  border-left: 2px solid var(--tech-blue-light);
  background: white;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  border-radius: 0 6px 6px 0;
}

.role-header {
  margin-bottom: var(--tech-space-md);
  padding-bottom: var(--tech-space-sm);
  border-bottom: 1px solid var(--tech-border);
}

.role-header h3 {
  margin: 0 0 var(--tech-space-sm) 0 !important;
  font-size: var(--tech-heading-md) !important;
  color: var(--tech-navy) !important;
}

.company {
  font-weight: 600;
  color: var(--tech-blue);
  font-size: var(--tech-text-lg);
  margin-bottom: var(--tech-space-xs);
}

.duration {
  color: var(--tech-gray-med);
  font-weight: 500;
  font-size: var(--tech-text-sm);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.role-description {
  font-size: var(--tech-text-lg);
  line-height: 1.6;
  color: var(--tech-gray-dark);
  margin-bottom: var(--tech-space-md);
}

.role-projects {
  margin-top: var(--tech-space-lg);
  padding-top: var(--tech-space-lg);
  border-top: 1px solid var(--tech-border);
}

.role-projects h4 {
  font-size: var(--tech-text-lg) !important;
  color: var(--tech-navy) !important;
  margin-bottom: var(--tech-space-md) !important;
  text-transform: uppercase !important;
  font-size: var(--tech-text-base) !important;
  letter-spacing: 1px !important;
}

.project-summary {
  margin-bottom: var(--tech-space-lg);
  padding: var(--tech-space-md);
  background: var(--tech-gray-light);
  border-radius: 6px;
  border: 1px solid var(--tech-border);
  position: relative;
}

.project-summary strong {
  color: var(--tech-navy);
  font-size: var(--tech-text-lg);
  font-weight: 600;
}

.project-summary p {
  margin-top: var(--tech-space-sm);
  margin-bottom: 0;
  color: var(--tech-gray-dark);
  font-size: var(--tech-text-base);
  line-height: 1.5;
}

/* TECHNICAL SKILLS - Badge/Tag style */
.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: var(--tech-space-lg);
  margin: var(--tech-space-lg) 0;
}

.skill-category {
  padding: var(--tech-space-lg);
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  border-top: 4px solid var(--tech-blue-light);
}

.skill-category h4 {
  margin: 0 0 var(--tech-space-md) 0 !important;
  font-size: var(--tech-text-lg) !important;
  font-weight: 600 !important;
  color: var(--tech-navy) !important;
  text-transform: uppercase !important;
  letter-spacing: 1px !important;
}

.skill-category h4 a {
  color: var(--tech-navy);
  text-decoration: none;
}

.skill-category h4 a:hover {
  color: var(--tech-blue);
  text-decoration: underline;
}

.skill-category ul {
  list-style: none !important;
  margin: 0 !important;
  padding: 0 !important;
  display: flex;
  flex-wrap: wrap;
  gap: var(--tech-space-xs);
}

.skill-category li {
  list-style: none !important;
  padding: var(--tech-space-xs) var(--tech-space-sm);
  background: var(--tech-blue-light);
  color: white;
  border-radius: 20px;
  font-size: var(--tech-text-sm);
  font-weight: 500;
  white-space: nowrap;
  transition: all 0.2s ease;
}

.skill-category li:hover {
  background: var(--tech-blue);
  transform: translateY(-1px);
}

/* PERSONAL ACCOMPLISHMENTS - Achievement cards */
.page-resume .post-content > ul,
body.page-resume .post-content > ul {
  list-style: none !important;
  padding: 0 !important;
  margin: var(--tech-space-lg) 0 !important;
}

.page-resume .post-content > ul > li,
body.page-resume .post-content > ul > li {
  margin-bottom: var(--tech-space-lg) !important;
  padding: var(--tech-space-lg) !important;
  background: white !important;
  border-radius: 8px !important;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1) !important;
  border-left: 2px solid var(--tech-blue-light) !important;
  font-size: var(--tech-text-lg) !important;
  line-height: 1.6 !important;
}

.page-resume .post-content > ul > li strong,
body.page-resume .post-content > ul > li strong {
  color: var(--tech-navy) !important;
  font-size: var(--tech-text-lg) !important;
  font-weight: 600 !important;
}

/* RESPONSIVE DESIGN */
@media (max-width: 768px) {
  :root {
    --tech-heading-lg: 1.75rem;
    --tech-heading-md: 1.25rem;
    --tech-text-lg: 1rem;
  }
  
  .page-resume .post-content,
  body.page-resume .post-content {
    padding: var(--tech-space-md) !important;
  }
  
  .skills-grid {
    grid-template-columns: 1fr;
    gap: var(--tech-space-md);
  }
  
  .qualification-header,
  .role-header {
    flex-direction: column;
    gap: var(--tech-space-sm);
  }
  
  .qualification-title-info {
    min-width: auto;
  }
  
  .skill-category ul {
    justify-content: center;
  }
}
</style>

<script>
// Add page-specific class for CSS targeting
document.documentElement.classList.add('page-resume');
document.body.classList.add('page-resume');
</script>