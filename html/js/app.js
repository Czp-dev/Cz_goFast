
window.addEventListener('load', (event) =>{
    const container = document.querySelector('.container')
    const first = document.querySelector('.mission')
    const map = document.querySelector('.map')
    const map1 = document.querySelector('.map1')
    const map2 = document.querySelector('.map2')
    const map3 = document.querySelector('.map3')
    const firstM = document.querySelector('.mission1')
    const sencondM = document.querySelector('.mission2')
    const thridM = document.querySelector('.mission3')
    container.style.display = 'none';

    window.addEventListener('message', (event) => {
        let data = event.data
        if (data.action === 'open'){
            container.style.display ='flex';
        }else if (data.action === 'close') {
            container.style.display ='none';
        }
    })

    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            fetch('https://Czp_gofast/closeall')
        }
    })

    document.querySelector('#firstMission').addEventListener('click', (event) =>{
        first.style.display = 'none';
        firstM.style.display = 'flex';
        map.style.display = 'none';
        map1.style.display = 'flex';
    })

    document.querySelector('#secondMission').addEventListener('click', (event) =>{
        first.style.display = 'none';
        sencondM.style.display = 'flex';
        map.style.display = 'none';
        map2.style.display = 'flex';
    })

    document.querySelector('#thirdMission').addEventListener('click', (event) =>{
        first.style.display = 'none';
        thridM.style.display = 'flex';
        map.style.display = 'none';
        map3.style.display = 'flex';
    })


    
    document.querySelector('#back').addEventListener('click', (event) => {
        first.style.display = 'flex';
        firstM.style.display = 'none';
        map.style.display = 'flex';
        map1.style.display = 'none';
    })

    document.querySelector('#back2').addEventListener('click', (event) => {
        first.style.display = 'flex';
        sencondM.style.display = 'none';
        map.style.display = 'flex';
        map2.style.display = 'none';
    })

    document.querySelector('#back3').addEventListener('click', (event) => {
        first.style.display = 'flex';
        thridM.style.display = 'none';
        map.style.display = 'flex';
        map3.style.display = 'none';
    })
    
    document.querySelector('#take1').addEventListener('click', (event) =>{
        fetch('https://Czp_gofast/firstMission')
    })

    document.querySelector('#take2').addEventListener('click', (event) =>{
        fetch('https://Czp_gofast/secondMission')
    })

    document.querySelector('#take3').addEventListener('click', (event) =>{
        fetch('https://Czp_gofast/thirdMission')
    })
})