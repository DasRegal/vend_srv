$(document).on('rails_admin.dom_ready', function() {
  const target = document.querySelector('.json-editor-target');

  if (target && typeof JSONEditor !== 'undefined' && !target.dataset.initialized) {
    const container = document.createElement('div');
    container.style.width = '600px';
    container.style.height = '400px';
    container.style.display = 'block';
    container.style.marginBottom = '20px';
    container.className = 'jsoneditor-container';
    target.parentNode.insertBefore(container, target);

    const options = {
      mode: 'form',
      modes: ['tree', 'code', 'text', 'form', 'view', 'preview'],
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
