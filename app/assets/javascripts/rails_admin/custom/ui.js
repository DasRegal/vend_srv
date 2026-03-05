$(document).on('rails_admin.dom_ready', function() {
  const target = document.querySelector('.json-editor-target');
  
  // Проверяем, загружена ли библиотека и есть ли поле
  if (target && typeof JSONEditor !== 'undefined' && !target.dataset.initialized) {
    const container = document.createElement('div');
    container.style.width = '600px';
    container.style.height = '400px';
    container.style.display = 'block';
    container.style.marginBottom = '20px';
    container.className = 'jsoneditor-container';
    target.parentNode.insertBefore(container, target);

    const options = {
      mode: 'tree',
      modes: ['tree', 'code', 'text'],
      onChange: function() {
        try {
          target.value = JSON.stringify(editor.get());
        } catch (err) {}
      }
    };


    const editor = new JSONEditor(container, options);
    editor.set(JSON.parse(target.value || '{}'));
    target.dataset.initialized = "true";
    target.style.display = 'none';
  }
});
