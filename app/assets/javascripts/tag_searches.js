// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const handleTagClick = function(e) {

    const checked = !e.childNodes[0].checked;
    const num = e.parentNode.parentNode.parentNode.parentNode.id.split('-')[2];
    const ref = document.getElementById(`selected_items-${num}`);
    const text = e.childNodes[2].innerText;
    
    if (checked) {
      const node = document.createElement("LI");
      const textnode = document.createTextNode(text);
      
      node.appendChild(textnode);

      ref.appendChild(node);
    } else {

      const arr = Array.from(ref.children);

      const ind = arr.findIndex(li => {
        return li.innerText === text;
      })

      ref.removeChild(ref.childNodes[ind]);
    }
    
}